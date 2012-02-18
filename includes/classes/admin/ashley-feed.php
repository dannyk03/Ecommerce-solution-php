<?php
/**
 * Handles ashley import
 *
 * @package Imagine Retailer
 * @since 1.0
 */
class Ashley_Feed extends Base_Class {
	const FTP_URL = 'ftp.ashleyfurniture.com';
	
	/**
	 * Creates new Database instance
	 *
	 * @return  void
	 */
	public function __construct() {
		// Load database library into $this->db (can be omitted if not required)
		parent::__construct();
		
		// Time how long we've been on this page
		$this->timer_start();
		$this->curl = new curl();
		$this->w = new Websites();
		$this->file = new Files();
		
	}

	/**
     *  Get websites to run
     *
     * @return bool
     */
    public function run_all() {
        $website_ids = $this->db->get_col( "SELECT `website_id` FROM `website_settings` WHERE `key` = 'ashley-ftp-password' AND `value` <> ''" );

        // Handle any error
		if ( $this->db->errno() ) {
			$this->err( 'Failed to get website_ids.', __LINE__, __METHOD__ );
			return false;
		}
		
		// Get the file if htere is one
		$file = ( isset( $_GET['f'] ) ) ? $_GET['f'] : NULL;
		
        if ( is_array( $website_ids ) )
        foreach( $website_ids as $wid ) {
			echo "<h1>$wid</h1>";
            $this->run( $wid, $file );
        }

        return true;
    }

	/**
	 * Main function, goes to page and grabs everything needed and does required actions.
	 * 
	 * @param int $website_id
	 * @param string $file (optional|)
	 * @return bool
	 */
	public function run( $website_id, $file = '' ) {
		$this->timer_start();
		
        // Get the settings
		$settings = $this->w->get_settings( $website_id, array( 'ashley-ftp-username', 'ashley-ftp-password' ) );
		
		$username = security::decrypt( base64_decode( $settings['ashley-ftp-username'] ), ENCRYPTION_KEY );
		$password = security::decrypt( base64_decode( $settings['ashley-ftp-password'] ), ENCRYPTION_KEY );
		
		// Initialize variables
		$folder = str_replace( 'CE_', '', $username );
		$products = $this->get_website_product_skus( $website_id );
		
		if ( !is_array( $products ) )
			$products = array();
		
		$ftp = new FTP( 0, "/CustEDI/$folder/Outbound/", true );
		ini_set( 'max_execution_time', 600 ); // 10 minutes
		ini_set( 'memory_limit', '512M' );
		set_time_limit( 600 );
		$start = time();


		// Set login information
		$ftp->host     = self::FTP_URL;
		$ftp->username = $username;
		$ftp->password = $password;
		$ftp->port     = 21;
		
		// Connect
		$ftp->connect();
		
		if( empty( $file ) ) {
			// Get al ist of the files
			$files = $ftp->dir_list();
			
			$file = $files[count($files)-1];
		}
		
		$local_folder = "/home/imaginer/public_html/admin/media/downloads/ashley/$username/";
		
		if ( !file_exists( $local_folder ) )
			mkdir( $local_folder, 0777 );
		
		// Grab the latest file
		if( file_exists( $local_folder . $file ) ) {
			$this->xml = simplexml_load_file( $local_folder . $file );
		} else {
			$this->xml = simplexml_load_string( $ftp->ftp_get_contents( $file ) );
		}
		
		// Generate array of our items
		foreach( $this->xml->items->item as $item ) {
			$sku = trim( $item->itemIdentification->itemIdentifier[0]->attributes()->itemNumber );
			
			if ( !array_key_exists( $sku, $products ) ) {
				$new_products[] = $sku;
			}
			
			$skus[] = $sku;
		}
		
		$remove_products = array();
		
		if ( is_array( $products ) )
		foreach ( $products as $sku => $product_id ) {
			if ( !in_array( $sku, $skus ) )
				$remove_products[] = (int) $product_id;
		}
		
		echo '<p><strong>New Products:</strong> ' . count( $new_products ) . '</p>';
		
		// Add new products
		$this->add_bulk( $website_id, $new_products );

		echo '<p><strong>Old Products:</strong> ' . count( $remove_products ) . '</p>';
		
		// Deactivate old products
		$this->deactivate_old_products( $website_id, $remove_products );
		
		// Reorganize Categories
		$this->reorganize_categories( $website_id );
		
		echo $this->scratchy_time();
	}
	
	/**
	 * Gets the products SKUs of a website to determine what products they have
	 *
	 * @param int $website_id
	 * @return array
	 */
	private function get_website_product_skus( $website_id ) {
		// Type Juggling
		$website_id = (int) $website_id;
		
		// Get Products
		$products = $this->db->get_results( "SELECT a.`product_id`, b.`sku` FROM `website_products` AS a LEFT JOIN `products` AS b ON ( a.`product_id` = b.`product_id` ) WHERE a.`website_id` = $website_id AND a.`active` = 1 AND b.`user_id_created` = 0", ARRAY_A );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->err( 'Failed to get products.', __LINE__, __METHOD__ );
			return false;
		}
		
		// Reform the array
		return ar::assign_key( $products, 'sku', true );
	}
	
	/**
	 * Add Bulk
	 *
	 * @param int $website_id
	 * @param string $product_skus
	 * @return bool
	 */
	private function add_bulk( $website_id, $product_skus ) {
        // Make sure they entered in SKUs
        if ( !is_array( $product_skus ) || empty( $product_skus ) )
            return false;
		
		$product_sku_chunks = array_chunk( $product_skus, 500 );
		
		foreach ( $product_sku_chunks as $product_skus ) {
			// Escape all the SKUs
			foreach ( $product_skus as &$ps ) {
				$ps = "'" . $this->db->escape( trim( $ps ) ) . "'";
			}
			
			// Turn it into a string
			$product_skus = implode( ",", $product_skus );
			
			// Get industries
			$industries = preg_replace( '/[^0-9,]/', '', implode( ',', $this->get_website_industries( $website_id ) ) );
	
			if ( $industries == '' )
				return array( false, 0, true );
	
			// Type Juggling
			$website_id = (int) $website_id;
			
			// Magical Query #1
			// Insert website products
			$this->db->query( "INSERT INTO `website_products` ( `website_id`, `product_id` ) SELECT DISTINCT $website_id, `product_id` FROM `products` WHERE `industry_id` IN($industries) AND `publish_visibility` = 'public' AND `status` <> 'discontinued' AND `sku` IN ( $product_skus ) ON DUPLICATE KEY UPDATE `active` = 1" );
			
			// Handle any error
			if ( $this->db->errno() ) {
				$this->err( 'Failed to dump website products.', __LINE__, __METHOD__ );
				return false;
			}
		}
		
		return true;
	}
	
	/**
	 * Deactivate old products
	 *
	 * @param int $website_id
	 * @param array $product_ids
	 * @return bool
	 */
	private function deactivate_old_products( $website_id, $product_ids ) {
		if ( !is_array( $product_ids ) || 0 == count( $product_ids ) )
			return;
		
		// Type Juggling
		$website_id = (int) $website_id;
		
		// Deactivate in chunks of 500
		$product_id_chunks = array_chunk( $product_ids, 500 );
		
		foreach ( $product_id_chunks as $product_ids_array ) {
			// Make sure the product_ids are valid
			foreach ( $product_ids_array as &$pid ) {
				$pid = (int) $pid;
			}
			
			$this->db->query( "UPDATE `website_products` SET `active` = 0 WHERE `website_id` = $website_id AND `product_id` IN(" . implode( ',', $product_ids_array ) . ')' );
			
			// Handle any error
			if ( $this->db->errno() ) {
				$this->err( 'Failed to deactivate products.', __LINE__, __METHOD__ );
				return false;
			}
		}
		
		return true;
	}
	
	/**
	 * Reorganize Categories
	 *
	 * @param int $website_id
	 * @return bool
	 */
	public function reorganize_categories( $website_id ) {
		// Get category IDs
		$category_ids = $this->db->get_col( "SELECT DISTINCT b.`category_id` FROM `website_products` AS a LEFT JOIN `product_categories` AS b ON ( a.`product_id` = b.`product_id` ) WHERE a.`website_id` = $website_id AND a.`active` = 1" );

		// Handle any error
		if ( $this->db->errno() ) {
			$this->err( 'Failed to get product categories.', __LINE__, __METHOD__ );
			return false;
		}
		
		// IF NULL exists, remove it
		if ( $key = array_search( NULL, $category_ids ) )
			unset( $category_ids[$key] );
		
		// Get website category IDs
		$website_category_ids = $this->db->get_col( "SELECT DISTINCT `category_id` FROM `website_categories` WHERE `website_id` = $website_id" );

		// Handle any error
		if ( $this->db->errno() ) {
			$this->err( 'Failed to get website product categories.', __LINE__, __METHOD__ );
			return false;
		}
		
		// IF NULL exists, remove it
		if ( $key = array_search( NULL, $website_category_ids ) )
			unset( $website_category_ids[$key] );
		
		// Need to get the parent categories
		$c = new Categories;
		
		$new_category_ids = $product_category_ids = $remove_category_ids = array();
		
		// Find out what categories we need to add
		if ( is_array( $category_ids ) )
		foreach ( $category_ids as $cid ) {
			if ( empty( $cid ) )
				continue;
			
			// Start forming complete list of product categories
			$product_category_ids[] = $cid;
			
			// If the website does not already have it and it has not already been added
			if ( !in_array( $cid, $website_category_ids ) && !in_array( $cid, $new_category_ids ) )
				$new_category_ids[] = $cid;
			
			// Get the parent categories of this category
			$parent_category_ids = $c->get_parent_category_ids( $cid );
			
			// Loop through parent ids
			if ( is_array( $parent_category_ids ) )
			foreach ( $parent_category_ids as $pcid ) {
				// Forming complete list 
				$product_category_ids[] = $pcid;
				
				// If the website does not already have it and it has not already been added
				if ( !in_array( $pcid, $website_category_ids ) && !in_array( $pcid, $new_category_ids ) )
					$new_category_ids[] = $pcid;
			}
		}
		
		// Only want the unique values
		$product_category_ids = array_unique( $product_category_ids );
		
		// IF NULL exists, remove it
		if ( $key = array_search( NULL, $product_category_ids ) )
			unset( $product_category_ids[$key] );
		
		sort( $product_category_ids );
		
		foreach ( $website_category_ids as $wcid ) {
			if ( !in_array( $wcid, $product_category_ids ) )
				$remove_category_ids[] = $wcid;
		}
		
		echo '<p><strong>New Categories:</strong> ' . count( $new_category_ids ) . '</p>';
		
		// Bulk add categories
		$this->bulk_add_categories( $website_id, $new_category_ids, $c );
		
		echo '<p><strong>Old Categories:</strong> ' . count( $remove_category_ids ) . '</p>';
		
		// Remove extra categoryes
		$this->remove_categories( $website_id, $remove_category_ids );
		
		return true;
	}
	
	/**
	 * Bulk Add categories
	 *
	 * @param int $website_id
	 * @param array $category_ids
	 * @param object $c (Category)
	 * @return bool
	 */
	private function bulk_add_categories( $website_id, $category_ids, $c ) {
		if ( !is_array( $category_ids ) || 0 == count( $category_ids ) )
			return;
		
		// Type Juggling
		$website_id = (int) $website_id;
		
		// If there are any categories that need to be added
		$category_images = $this->db->get_results( "SELECT a.`category_id`, CONCAT( 'http://', c.`name`, '.retailcatalog.us/products/', b.`product_id`, '/', d.`image` ) FROM `product_categories` AS a LEFT JOIN `products` AS b ON ( a.`product_id` = b.`product_id` ) LEFT JOIN `industries` AS c ON ( b.`industry_id` = c.`industry_id` ) LEFT JOIN `product_images` AS d ON ( b.`product_id` = d.`product_id` ) LEFT JOIN `website_products` AS e ON ( b.`product_id` = e.`product_id` ) WHERE a.`category_id` IN(" . implode( ',', $category_ids ) . ") AND b.`publish_visibility` = 'public' AND b.`status` <> 'discontinued' AND d.`sequence` = 0 AND e.`website_id` = $website_id AND e.`product_id` IS NOT NULL GROUP BY a.`category_id`", ARRAY_A );

		// Handle any error
		if ( $this->db->errno() ) {
			$this->err( 'Failed to get website category images.', __LINE__, __METHOD__ );
			return false;
		}
		
		// Create insert
		$values = '';
		$category_images = ar::assign_key( $category_images, 'category_id', true );
		
		foreach ( $category_ids as $cid ) {
			// If we have an image, use it
			if ( isset( $category_images[$cid] ) ) {
				$image = $this->db->escape( $category_images[$cid] );
			} else {
				// If not, that means it is a parent category. Choose the first child category with an image, and use it
				
				// Get child categories
				$child_categories = $c->get_child_categories( $cid );
				
				// Find the first available image
				foreach ( $child_categories as $cc ) {
					if ( isset( $category_images[$cc['category_id']] ) ) {
						// Assign the image
						$image = $this->db->escape( $category_images[$cc['category_id']] );
						
						// Don't need to loop any furhter
						break;
					}
				}
			}
			
			// Create the CSV
			if ( !empty( $values ) )
				$values .= ',';
			
			// Create the values
			$values .= "( $website_id, $cid, '$image' )";
		}
		
		// Add the values
		if ( !empty( $values ) ) {
			$this->db->query( "INSERT INTO `website_categories` ( `website_id`, `category_id`, `image_url` ) VALUES $values ON DUPLICATE KEY UPDATE `category_id` = VALUES( `category_id` )" );

			// Handle any error
			if ( $this->db->errno() ) {
				$this->err( 'Failed to add website categories.', __LINE__, __METHOD__ );
				return false;
			}
		}
		
		return true;
	}
	
	/**
	 * Remove Categories from a website
	 *
	 * @param int $website_id
	 * @param array $category_ids
	 * @return bool
	 */
	private function remove_categories( $website_id, $category_ids ) {
		// Type Juggling
		$website_id = (int) $website_id;
		
		// Make sure we're dealing with an array
		if ( !is_array( $category_ids ) || 0 == count( $category_ids ) )
			return true;
		
		// Make sure they're MySQL safe
		foreach ( $category_ids as &$cid ) {
			$cid = (int) $cid;
		}
		
		$this->db->query( "DELETE FROM `website_categories` WHERE `website_id` = $website_id AND `category_id` IN(" . implode( ',', $category_ids ) . ')' );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->err( 'Failed to delete website categories.', __LINE__, __METHOD__ );
			return false;
		}
		
		return true;
	}
	
	/**
	 * Get website industries
	 *
	 * @param int $website_id
	 * @return array
	 */
	private function get_website_industries( $website_id ) {
		// Type Juggling
		$website_id = (int) $website_id;
		
		$industry_ids = $this->db->get_col( "SELECT `industry_id` FROM `website_industries` WHERE `website_id` = $website_id" );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->err( 'Failed to get industry ids.', __LINE__, __METHOD__ );
			return false;
		}
		
		return $industry_ids;
	}
	
	/**
	 * Logs in
	 *
	 * @since 1.0.0
	 *
	 * @return true
	 */
	private function login() {
		$this->curl->post( $this->login_url, $this->login_post_fields );
		return true;
	}
	
	/**
	 * Starts the timer, for debugging purposes.
	 *
	 * @since 1.0.0
	 */
	private function timer_start() {
		$this->time_start = microtime( true );
	}

	/**
	 * Stops the debugging timer.
	 *
	 * @since 1.0.0
	 *
	 * @return int Total time spent on the query, in seconds
	 */
	private function scratchy_time() {
		return microtime( true ) - $this->time_start;
	}
	
	/**
	 * Report an error
	 *
	 * Make the parent error function a little less complicated
	 *
	 * @param string $message the error message
	 * @param int $line (optional) the line number
	 * @param string $method (optional) the class method that is being called
     * @return bool
	 */
	private function err( $message, $line = 0, $method = '' ) {
		return $this->error( $message, $line, __FILE__, dirname(__FILE__), '', __CLASS__, $method );
	}
}