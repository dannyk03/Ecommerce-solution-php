<?php
/**
 * Handles all the craiglist functions
 *
 * @package Imagine Retailer
 * @since 1.0
 */
class Craigslist extends Base_Class {
	/**
	 * Construct initializes data
	 */
	public function __construct() {
		// Need to load the parent constructor
		if( !parent::__construct() )
			return false;
	}
	
	/**
	 * Gets craigslist ads
	 *
	 * @param array $variables( $where, $order_by, $limit )
	 * @return array $craigslist_ads
	 */
	public function get_craigslist_ads( $variables ) {
		// Get the variables
		list( $where, $order_by, $limit ) = $variables;
		
		$craigslist_ads = $this->db->get_results( "SELECT a.`title`, a.`craigslist_ad_id`, a.`text`, a.`duration`, 
												 c.`name` AS `product_name`, c.`sku`, a.`date_created`, UNIX_TIMESTAMP( a.`date_posted` ) AS date_posted 
												 FROM `craigslist_ads` AS a 
												 LEFT JOIN `products` AS c ON( a.product_id = c.product_id ) 
												 WHERE a.`active` = '1' $where GROUP BY a.`craigslist_ad_id` $order_by LIMIT $limit", ARRAY_A );
		
		// Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to get craigslist ads.', __LINE__, __METHOD__ );
			return false;
		}
		
		return $craigslist_ads;
	}

    	/**
	 * Countscraigslist ads
	 *
	 * @param string $where
	 * @return int
	 */
	public function count_craigslist_ads( $where ) {
		// @Fix need to make this count without PHP's count
		$craigslist_ad_ids = $this->db->get_results( "SELECT a.`craigslist_ad_id` FROM `craigslist_ads` AS a LEFT JOIN `products` AS c ON( a.product_id = c.product_id ) WHERE a.`active` = '1' $where GROUP BY a.`craigslist_ad_id`", ARRAY_A );

		// Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to count craigslist ads.', __LINE__, __METHOD__ );
			return false;
		}

		return count( $craigslist_ad_ids );
	}
	
	/**
	 * Gets a single ad
	 *
	 * @param int $craigslist_ad_id
	 * @return array
	 */
	public function get( $craigslist_ad_id ) {
		$results = $this->db->prepare( "SELECT a.`title`, a.`craigslist_ad_id`, a.`text`, a.`duration`, a.`product_id`,
									  			 b.`title` AS store_name,
												 c.`name` AS product_name, 
												 c.`sku`, 
												 UNIX_TIMESTAMP( a.`date_created` ) AS date_created, UNIX_TIMESTAMP( a.`date_posted` ) AS date_posted 
												 FROM `craigslist_ads` AS a 
												 LEFT JOIN `websites` AS b ON ( a.`website_id` = b.`website_id` ) 
												 LEFT JOIN `products` AS c ON ( a.product_id = c.product_id ) 
												 WHERE a.`craigslist_ad_id` = ? LIMIT 1", 'i', $craigslist_ad_id )->get_row('', ARRAY_A);
		
		// Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to get craigslist ads.', __LINE__, __METHOD__ );
			return false;
		}
		
		return $results;
	}

    /**
	 * Gets a random headline
	 *
	 * @param int $category_id
	 * @return string
	 */
	public function get_random_headline( $category_id ) {
        // Type Juggling
        $category_id = (int) $category_id;

		$headlines = $this->db->get_col( "SELECT `headline` FROM `craigslist_headlines` WHERE `category_id` = $category_id" );

		// Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to get craigslist headline.', __LINE__, __METHOD__ );
			return false;
		}

        // Get a random headline
        $headline = $headlines[rand( 0, count( $headlines ) - 1 )];

		return ( isset( $headline ) ) ? $headline : '';
	}
	
	/**
	 * Creates a new Craigslist ad
	 *
	 * @param int $product_id
	 * @param int $website_id
	 * @param int $duration
	 * @param string $title
	 * @param string $text
	 * @param int $active
	 * @param bool $publish
	 * @return int craigslist_ad_id
	 */
	public function create( $product_id, $website_id, $duration, $title, $text, $active, $publish ) {

        $date = ( $publish ) ? date( "Y-m-d H:i:s", time() ) : "0";
		$result = $this->db->insert( 'craigslist_ads', array(
            'product_id' => $product_id,
            'website_id' => $website_id,
            'duration' => $duration,
            'title' => $title,
            'text' => $text,
            'active' => $active,
            'date_created' => date( "Y-m-d H:i:s", time() ),
            'date_posted' => $date
        ), 'iiississ' );
		
		// Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to create Craigslist Ad.', __LINE__, __METHOD__ );
			return false;
		}
		return $result;
	}
	
	/**
	 * Deletes a craigslist ad from the database
	 *
	 * @param int $craigslist_ad_id
	 * @return bool
	 */
	public function delete( $craigslist_ad_id ) {			
		$this->db->update( 'craigslist_ads', array( 'active' => '0' ), array( 'craigslist_ad_id' => $craigslist_ad_id ), 'i', 'i' );
		
		// Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to delete Craigslist Ad.', __LINE__, __METHOD__ );
			return false;
		}
		return true;
	}
	
	/**
	 * Clones a craigslist ad from the database
	 *
	 * @since 1.0.0
	 *
	 * @var int $craigslist_ad_id
	 * @return bool false if couldn't delete
	 */
	public function copy( $craigslist_ad_id ) {
		$ad = $this->db->prepare( "SELECT `product_id`, `website_id`, `title`, `text`, `craigslist_city_id`, `craigslist_category_id`, `craigslist_district_id` FROM `craigslist_ads` WHERE `craigslist_ad_id` = ?", 'i', $craigslist_ad_id )->get_row('', ARRAY_A);

        // Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to get craigslist details.', __LINE__, __METHOD__ );
			return false;
		}

        $this->db->insert( 'craigslist_ads', array( 'product_id' => $ad['product_id'], 'website_id' => $ad['website_id'], 'title' => $ad['title'], 'text' => $ad['text'], 'craigslist_city_id' => $ad['craigslist_city_id'], 'craigslist_category_id' => $ad['craigslist_category_id'], 'craigslist_district_id' => $ad['craigslist_district_id'], 'date_created' => date( "Y-m-d H:i:s", time() ) ), 'iissiiis' );
		
		// Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to copy Craigslist Ad.', __LINE__, __METHOD__ );
			return false;
		}
		return true;
	}
	
	/**
	 * Updates an existing Craigslist ad
	 *
	 * @param int $craigslist_ad_id
	 * @param int $product_id
	 * @param int $website_id
	 * @param int $duration
	 * @param string $title
	 * @param string $text
	 * @param int $active
	 * @param bool $publish
	 * @return int craigslist_ad_id
	 */
	public function update( $craigslist_ad_id, $product_id, $website_id, $duration, $title, $text, $active, $publish ){
		$date = ( $publish ) ? date( "Y-m-d H:i:s", time() ) : "0";
		$result = $this->db->update( 'craigslist_ads', array(
            'product_id' => $product_id,
            'website_id' => $website_id,
            'duration' => $duration,
            'title' => $title,
            'text' => $text,
            'active' => $active,
            'date_updated' => date( "Y-m-d H:i:s", time() ),
            'date_posted' => $date
        ), array( 'craigslist_ad_id' => $craigslist_ad_id ), 'iiississ', 'i' );
		
		// Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to update Craigslist Ad.', __LINE__, __METHOD__ );
			return false;
		}
		return $result;
	}

    /**
     * Download Craigslist
     *
     * @return array
     */
    public function download() {
        global $user;

        // Type Juggling
        $website_id = $user['website']['website_id'];

        $craigslist_ads = $this->db->get_results( "SELECT a.`title`, a.`text`, b.`description`, b.`name`,b.`sku`, c.`category_id`, d.`name` AS category, e.`name` AS brand, CONCAT( 'http://', g.`name`, '.retailcatalog.us/products/', b.`product_id`, '/', f.`image` ) AS image FROM `craigslist_ads` AS a LEFT JOIN `products` AS b ON ( a.`product_id` = b.`product_id` ) LEFT JOIN `product_categories` AS c ON ( a.`product_id` = c.`product_id`) LEFT JOIN `categories` AS d ON ( c.`category_id` = d.`category_id` ) LEFT JOIN `brands` AS e ON ( b.`brand_id` = e.`brand_id` ) LEFT JOIN `product_images` AS f ON ( b.`product_id` = f.`product_id` ) LEFT JOIN `industries` AS g ON ( b.`industry_id` = g.`industry_id` ) WHERE a.`website_id` = $website_id AND a.`active` = 1 AND a.`product_id` <> 0 AND f.`sequence` = 0", ARRAY_A );

        // Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to get Craigslist Ads.', __LINE__, __METHOD__ );
			return false;
		}

        $c = new Categories();

        foreach( $craigslist_ads as &$cad ) {
            $category = $c->get_top( $cad['category_id'] );
            $cad['top_category'] = $category['name'];
        }

        return $craigslist_ads;
    }

    /**
     * Get Craigslist Market
     *
     * @param int $craigslist_market_id
     * @return array
     */
    public function get_craigslist_market( $craigslist_market_id ) {
        global $user;

        // Type Juggling
        $website_id = (int) $user['website']['website_id'];
        $craigslist_market_id = (int) $craigslist_market_id;

        $market = $this->db->get_row( "SELECT a.`craigslist_market_id`, CONCAT( a.`city`, ', ', IF( '' <> a.`area`, CONCAT( a.`state`, ' - ', a.`area` ), a.`state` ) ) AS market FROM `craigslist_markets` AS a LEFT JOIN `craigslist_market_links` AS b ON ( a.`craigslist_market_id` = b.`craigslist_market_id` ) WHERE a.`craigslist_market_id` = $craigslist_market_id AND b.`website_id` = $website_id", ARRAY_A );

        // Handle any error
		if( $this->db->errno() ) {
			$this->err( 'Failed to get Craigslist Market.', __LINE__, __METHOD__ );
			return false;
		}

        return $market;
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
