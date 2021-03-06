<?php
/**
 * Handles ashley import
 *
 * @package Grey Suit Retail
 * @since 1.0
 */
class AshleyExpressFeedGateway extends ActiveRecordBase {
	const FTP_URL = 'ftp.ashleyfurniture.com';
    const USER_ID = 353; // Ashley
    const COMPLETE_CATALOG_MINIMUM = 10485760; // 10mb In bytes

    protected $omit_sites = array( 161, 187, 296, 343, 341, 345, 371, 404, 456, 461, 464, 468, 492, 494, 501, 557, 572
        , 582, 588, 599, 606, 614, 641, 644, 649, 660, 667, 668, 702, 760, 928, 897, 911, 926, 972, 1011, 1016, 1032
        , 1034, 1071, 1088, 1091, 1105, 1112, 1117, 1118, 1119, 1152, 1156, 1204
    );

    /**
     * @var SimpleXMLElement
     */
    private $xml;

	/**
	 * Creates new Database instance
	 */
	public function __construct() {
		// Load database library into $this->db (can be omitted if not required)
		parent::__construct('');

        // Set specs to last longer
        ini_set( 'max_execution_time', 3600 ); // 1 hour
		ini_set( 'memory_limit', '512M' );
		set_time_limit( 3600 );

        if ( !class_exists( 'WebsiteOrder' ) ) {
            require_once MODEL_PATH . '../account/website-order.php';
            require_once MODEL_PATH . '../account/website-shipping-method.php';
        }
    }

    /**
     * Get Feed Accounts
     *
     * @return Account[]
     */
    protected function get_feed_accounts() {
        $accounts = $this->get_results( "SELECT ws.`website_id` FROM `website_settings` AS ws LEFT JOIN `websites` AS w ON ( w.`website_id` = ws.`website_id` ) LEFT JOIN `website_settings` AS ws2 ON ( ws2.`website_id` = w.`website_id` AND ws2.`key` = 'feed-last-run' ) WHERE ws.`key` = 'ashley-ftp-password' AND ws.`value` <> '' AND w.`status` = 1 ORDER BY ws2.`value`", PDO::FETCH_CLASS, 'Account' );
        foreach ( $accounts as $k => $account ) {
            $is_ashley_express = (bool)$account->get_settings( 'ashley-express' );
            if ( !$is_ashley_express ) {
                unset( $accounts[$k] );
            }
        }
        return $accounts;
    }

    /**
     * Get FTP
     *
     * @param Account $account
     * @return Ftp
     */
    public function get_ftp( Account $account ) {
        // Initialize variables
        $settings = $account->get_settings( 'ashley-ftp-username', 'ashley-ftp-password', 'ashley-alternate-folder', 'payment-gateway-status' );
        $username = security::decrypt( base64_decode( $settings['ashley-ftp-username'] ), ENCRYPTION_KEY );
        $password = security::decrypt( base64_decode( $settings['ashley-ftp-password'] ), ENCRYPTION_KEY );

        $folder = str_replace( 'CE_', '', $username );

        // Modify variables as necessary
        if ( '-' != substr( $folder, -1 ) )
            $folder .= '-';

        $payment_gateway_status = (bool) $settings['payment-gateway-status'];
        if ( $payment_gateway_status ) {
            $subfolder = ( '1' == $settings['ashley-alternate-folder'] ) ? 'Outbound/Items' : 'Outbound';
        } else {
            $subfolder = "/test";
        }

        // Setup FTP
        $ftp = new Ftp( "/CustEDI/$folder/$subfolder/" );

        // Set login information
        $ftp->host     = self::FTP_URL;
        $ftp->username = $username;
        $ftp->password = $password;
        $ftp->port     = 21;

        // Connect
        $ftp->connect();

        return $ftp;
    }

    /**
     * Get XML
     *
     * @param Account $account
     * @param string $prefix
     * @param bool $archive
     * @return SimpleXMLElement
     */
    private function get_xml( $account, $prefix = null, $archive = false ) {
        // Get FTP

        $ftp = $this->get_ftp( $account );

        // Figure out what file we're getting
        if( empty( $file ) ) {
            // Get al ist of the files
            $files = array_reverse( $ftp->raw_list() );

            foreach ( $files as $f ) {
                if ( 'xml' != f::extension( $f['name'] ) )
                    continue;

                $file_name = f::name( $f['name'] );
                if ( $prefix && strpos( $file_name, $prefix ) === false )
                    continue;

                $file = $f['name'];
            }
        }

        // Can't do anything without a file
        if ( empty( $file ) )
            return null;

        // Make sure the folder has been created
        $local_folder = sys_get_temp_dir() . '/';

        // Grab the latest file
        if( !file_exists( $local_folder . $file ) )
            $ftp->get( $file, '', $local_folder );

        $this->xml = simplexml_load_file( $local_folder . $file );

        // Now remove the file
        unlink( $local_folder . $file );

        if ( $archive ) {
            $dir_parts = explode( '/', trim( $ftp->cwd, '/' ) );
            array_pop( $dir_parts );
            $dir_parts[] = 'Archive';
            $archive_folder = '/' . implode( '/', $dir_parts ) . '/';

            @$ftp->mkdir( $archive_folder );
            $ftp->rename( $file, $archive_folder . $file );
        }

        return $this->xml;

    }

	/**
     *  Run Flag Products (all accounts)
     */
    public function run_flag_products_all() {
        // Get Feed Accounts
        $accounts = $this->get_feed_accounts();

        if ( is_array( $accounts ) )
        foreach( $accounts as $account ) {
            $this->run_flag_products( $account );
        }
    }

	/**
	 * Run Flag Products
     * This will flag all Ashley Express products so they can enter the Ashley Express program.
	 *
	 * @param Account $account
	 * @return bool
	 */
	public function run_flag_products( Account $account ) {

        // Get FTP
        $ftp = $this->get_ftp( $account );

        // Figure out what file we're getting
        $file = null;
        $to_delete = [];
        if( empty( $file ) ) {
            // Get al ist of the files
            $files = array_reverse( $ftp->raw_list() );

            foreach ( $files as $f ) {
                if ( 'xml' != f::extension( $f['name'] ) )
                    continue;

                $file_name = f::name( $f['name'] );
                if ( strpos( $file_name, '846-' ) === false )
                    continue;

                // get first file, remove olders
                if ( !$file )
                    $file = $f['name'];
                else
                    $to_delete[] = $f['name'];
            }
        }

        // Can't do anything without a file
        if ( $file ) {
            // Make sure the folder has been created
            $local_folder = sys_get_temp_dir() . '/';

            // Grab the latest file
            if( !file_exists( $local_folder . $file ) )
                $ftp->get( $file, '', $local_folder );

            $this->xml = simplexml_load_file( $local_folder . $file );

            // Now remove the file
            unlink( $local_folder . $file );
        }

        // delete older files
        foreach ( $to_delete as $file_to_delete ) {
            $ftp->delete( $file_to_delete );
        }


        if ( !$this->xml ) {
            // Remove all products from Ashley Express
            $this->flag_bulk( $account, array( ) );
            $this->flag_packages( $account, array( ) );
            return false;
        }

        // Declare array
        $ashley_express_skus = array();
        $check_carton_availability = array();

        // Set Settings: Ashley Express Buyer ID from XML
        $ns = $this->xml->getDocNamespaces();
//        if ( isset( $this->xml->inquiry->potentialBuyer ) ) {
//            $account->set_settings( array(
//                'ashley-express-buyer-id' => (string)$this->xml->inquiry->potentialBuyer->children( $ns['fnParty'] )->attributes()->partyIdentifierCode
//            ) );
//        }

        // Generate array of our items
        /**
         * @var SimpleXMLElement $item
         */
        foreach ( $this->xml->items->itemAdvice as $item ) {

            $sku = $item->itemId->itemIdentifier['itemNumber'];

            foreach ( $item->itemAvailability as $availability ) {
                // Item is Ashley Express only if stock for current availability is greater than 5
                if ( $availability['availability'] == 'current' ) {

                    // If available quantity is 0, maybe it's not implemented from ashley side
                    // and we will need to get the stock from it's carton.
                    // http://admin.greysuitretail.com/tickets/ticket/?tid=32121
                    if ( $availability->availQty['value'] == 0 ) {
                        // Carton SKU is individual SKU except the last char.
                        $check_carton_availability[] = array( 'individual' => $sku, 'carton' => substr( $sku, 0, -1 ) );
                    }

                    if ( $availability->availQty['value'] > 5 ) {
                        $ashley_express_skus[] = $sku;
                    }
                    break;
                }
            }
		}

        // If available quantity is 0, maybe it's not implemented from ashley side
        // and we will need to get the stock from it's carton.
        // http://admin.greysuitretail.com/tickets/ticket/?tid=32121
        foreach ( $check_carton_availability as $carton_check ) {
            // If carton has stock, add the individual
            if ( in_array($carton_check['carton'], $ashley_express_skus ) ) {
                $ashley_express_skus[] = $carton_check['individual'];
            }
        }

        // Don't run if we are deleting more than 500 products
        $to_delete = $this->calculate_to_delete( $account, $ashley_express_skus );
        if ( $to_delete > 500 && !isset( $_GET['override'] ) ) {
            $ticket = new Ticket();
            $ticket->user_id = self::USER_ID; // Ashley
            $ticket->assigned_to_user_id = User::KERRY;
            $ticket->website_id = $account->id;
            $ticket->priority = Ticket::PRIORITY_HIGH;
            $ticket->status = Ticket::STATUS_OPEN;
            $ticket->summary = 'Ashley Express Feed - Removing Too Many Products';
            $ticket->message = 'Trying to remove ' . $to_delete . ' products. Click the following link to override:' . "\nhttp://admin.greysuitretail.com/accounts/run-ashley-express-feed/?aid={$account->id}&override=1";
            $ticket->create();
            return;
        }

        $account_ae_skus = $this->flag_bulk( $account, $ashley_express_skus );

        // Add Packages -------------------------------------------
        // --------------------------------------------------------
        $packages = $this->get_ashley_packages();
        $package_skus = array();
        $group_items = array();
        foreach( $account_ae_skus as $sku ) {
            // Setup packages
            if ( stristr( $sku, '-' ) ) {
                list( $series, $item ) = explode( '-', $sku, 2 );
            } else if ( strlen( $sku ) == 7 && is_numeric( $sku{0} ) ) {
                $series = substr( $sku, 0, 5 );
                $item = substr( $sku, 5 );
            } else if ( strlen( $sku ) == 8 && ctype_alpha( $sku{0} ) ) {
                $series = substr( $sku, 0, 6 );
                $item = substr( $sku, 6 );
            } else {
                continue;
            }
            $package_skus[$series][] = $item;
        }

        // Add packages if they have all the pieces
        foreach ( $packages as $series => $items ) {
            // Go through each item
            foreach ( $items as $product_id => $package_pieces ) {
                // See if they have all the items necessary
                foreach ( $package_pieces as $item ) {
                    // Check if it is a series such as "W123-45" or "W12345"
                    if ( is_array( $package_skus[$series] ) && in_array( $item, $package_skus[$series] ) ) {
                        $group_items[$series] = true;
                        continue;
                    }

                    if ( in_array( $series . $item, $account_ae_skus ) ) {
                        $group_items[$series] = true;
                        continue;
                    }

                    // If they don't have both, then stop this item
                    unset ( $group_items[$series] );
                    continue 2; // Drop out of both
                }

                // Add to packages list
                $ashley_package_product_ids[] = $product_id;
            }
        }

        $this->flag_packages( $account, $ashley_package_product_ids );

	}

    /**
     * Calculate rows to delete
     *
     * @param $account
     * @param $skus
     * @return int
     */
    private function calculate_to_delete( $account, $skus ) {
        $to_delete = $this->get_results("
                SELECT COUNT(*)
                FROM `website_product_ashley_express` wpae
                INNER JOIN `products` p ON ( p.`product_id` = wpae.`product_id` )
                WHERE wpae.`website_id` = {$account->website_id}
                  AND p.`user_id_created` = ". self::USER_ID ."
                  " . ( $skus ? ( "AND p.`sku` NOT IN ('". implode("','", $skus) ."')" ) : "" )
            , PDO::FETCH_COLUMN );

        return array_pop($to_delete);
    }

    /**
     * Flag a Bulk of Products as Ashley Express
     * Removes Flag for products that are no in $skus
     *
     * @param Account $account
     * @param string[] $skus array of skus
     * @return array with skus really added as AE
     */
    private function flag_bulk( $account, $skus ) {

        $this->prepare("
                DELETE wpae
                FROM `website_product_ashley_express` wpae
                INNER JOIN `products` p ON ( p.`product_id` = wpae.`product_id` )
                WHERE wpae.`website_id` = :website_id
                  AND p.`user_id_created` = :user_id_created
                  " . ( $skus ? ( "AND p.`sku` NOT IN ('". implode("','", $skus) ."')" ) : "" )
            , 'iii'
            , array(
                ':website_id' => $account->website_id
                , ':user_id_created' => self::USER_ID
            )
        )->query();

        // If no skus, there's nothing to add
        if ( !$skus )
            return;

        $this->prepare("
                INSERT IGNORE INTO `website_product_ashley_express` ( website_id, product_id )
                SELECT :website_id, p.product_id
                FROM `products` p
                INNER JOIN `website_product_ashley_express_master` wpaem ON p.`sku` = wpaem.`sku`
                WHERE p.`user_id_created` = :user_id_created
                  AND p.`publish_visibility` = 'public'
                  AND p.`status` = 'in-stock'
                  AND p.`sku` IN ('". implode("','", $skus) ."')"
            , 'iii'
            , array(
                ':website_id' => $account->website_id
                , ':user_id_created' => self::USER_ID
            )
        )->query();

        return $this->get_results("
            SELECT DISTINCT p.`sku`
            FROM products p
            INNER JOIN website_product_ashley_express wpae ON p.product_id = wpae.product_id
            WHERE wpae.website_id = {$account->website_id}"
            , PDO::FETCH_COLUMN
        );

    }

    /**
     * Flag Packages
     * @param Account $account
     * @param int[] $product_ids
     */
    private function flag_packages( $account, $product_ids ) {
        $this->prepare("
                DELETE wpae
                FROM `website_product_ashley_express` wpae
                INNER JOIN `products` p ON ( p.`product_id` = wpae.`product_id` )
                WHERE wpae.`website_id` = :website_id
                  AND p.`user_id_created` = :user_id_created
                  " . ( $product_ids ? ( "AND p.`product_id` NOT IN (". implode(",", $product_ids) .")" ) : "" )
            , 'iii'
            , array(
                ':website_id' => $account->website_id
                , ':user_id_created' => 1477
            )
        )->query();

        // If no skus, there's nothing to add
        if ( !$product_ids )
            return;

        $this->prepare("
                INSERT IGNORE INTO `website_product_ashley_express` ( website_id, product_id )
                SELECT :website_id, p.product_id
                FROM `products` p
                WHERE p.`user_id_created` = :user_id_created
                  AND p.`product_id` IN (". implode(",", $product_ids) .")"
            , 'iii'
            , array(
                ':website_id' => $account->website_id
                , ':user_id_created' => 1477
            )
        )->query();
    }

    /**
     *  Run Order Acknowledgement (all accounts)
     */
    public function run_order_acknowledgement_all() {
        // Get Feed Accounts
        $accounts = $this->get_feed_accounts();

        if ( is_array( $accounts ) )
            foreach( $accounts as $account ) {
                $this->run_order_acknowledgement( $account );
            }
    }

    /**
     * Run Order Acknowledgement
     * This will check for Orders response after they are created
     *
     * @param Account $account
     */
    public function run_order_acknowledgement( Account $account ) {

        echo "Working with Account {$account->id}\n";

        $account_user = new User();
        $account_user->get( $account->user_id );

        while( $this->get_xml( $account, '855-', true ) !== null ) {

            $order_id = (string)$this->xml->ackOrder->orderDocument['id'];
            echo "Order #$order_id \n";

            $order = new WebsiteOrder();
            $order->get( $order_id, $account->id );

            if ( !$order->id ) {
                echo "Order #$order_id not found under Account {$account->id}\n";
                continue;
            }
            echo "Order: ". json_encode($order) ." \n";

            if ( !$order->is_ashley_express() ) {
                echo "Order #$order_id is not Ashley Express {$order->website_shipping_method_id} {$order->website_ashley_express_shipping_method_id} \n";
                continue;
            }

            if ( $order->status != WebsiteOrder::STATUS_PURCHASED ) {
                echo "Order #$order_id has invalid Status {$order->status} \n";
                continue;
            }

            $order->status = WebsiteOrder::STATUS_RECEIVED;
            $order->save();
            echo "Order Updated!\n";

            $website_user = new WebsiteUser();
            $website_user->get( $order->website_user_id, $account->id );

        }

        echo "Finished with Account\n----\n";

    }

    /**
     * Run Order ASN (Advanced Ship Notice) (all accounts)
     */
    public function run_order_asn_all() {
        // Get Feed Accounts
        $accounts = $this->get_feed_accounts();

        if ( is_array( $accounts ) )
            foreach( $accounts as $account ) {
                $this->run_order_asn( $account );
            }
    }


    /**
     * Run Order ASN (Advanced Ship Notice)
     * This will check for Orders response after they are marked at Received by run_order_acknowledgement()
     *
     * @param Account $account
     */
    public function run_order_asn( Account $account ) {

        echo "Working with Account {$account->id}\n";

        while( $this->get_xml( $account, '856-', true ) !== null ) {

            $order_id = (string)$this->xml->shipment->order->orderReferenceNumber['referenceNumberValue'];
            echo "Order #$order_id \n";

            $order = new WebsiteOrder();
            $order->get( $order_id, $account->id );

            if ( !$order->id ) {
                echo "Order #$order_id not found under Account {$account->id}\n";
                continue;
            }
            echo "Order: ". json_encode($order) ." \n";

            if ( !$order->is_ashley_express() ) {
                echo "Order #$order_id is not Ashley Express {$order->website_shipping_method_id} {$order->website_ashley_express_shipping_method_id} \n";
                continue;
            }

            if ( $order->status != WebsiteOrder::STATUS_RECEIVED ) {
                echo "Order #$order_id has invalid Status {$order->status} \n";
                continue;
            }

            $shipping_track_numbers = array();
            try {
                foreach ( $this->xml->shipment->order->item as $item ) {
                    foreach ( $item->itemQuantity->unitsShipped->pieceIdentification->pieceIdentificationNumber as $identification ) {
                        $shipping_track_numbers[] = (string)$identification;
                    }
                }
            } catch ( Exception $e ) { }

            $order->shipping_track_number = implode( ',', $shipping_track_numbers );
            $order->status = WebsiteOrder::STATUS_SHIPPED;
            $order->save();
            echo "Order Updated\n";

            $this->shipped_order_email($order, $account);
            echo "Email Sent!\n";
        }

        echo "Finished with Account\n----\n";

    }

    /**
     * Get Ashley Packages
     *
     * @return array
     */
    protected function get_ashley_packages() {
        // Ashley Packages
        $products = ar::assign_key( $this->get_results( 'SELECT `product_id`, `sku` FROM `products` WHERE `user_id_created` = 1477', PDO::FETCH_ASSOC ), 'sku', true );

        $ashley_packages = array();

        // Return all Ashley Packages
        foreach ( $products as $sku => $product_id ) {
            $sku_pieces = explode( '/', $sku );

            // Remove anything within parenthesis on SKU Pieces
            $regex = '/\(([^)]*)\)/';
            foreach ( $sku_pieces as $k => $sp ) {
                $sku_pieces[$k] = preg_replace($regex, '', $sp);
            }

            $series = array_shift( $sku_pieces );

            $ashley_packages[$series][$product_id] = $sku_pieces;
        }

        // Remove Packages with no pieces
        foreach( $ashley_packages as $series => $packages ) {
            if ( empty( $packages ) ) {
                unset( $ashley_packages[$series] );
                continue;
            }

            foreach ( $packages as $package_product_id => $pieces ) {
                if ( empty( $pieces ) ) {
                    unset( $ashley_packages[$series][$package_product_id] );
                }
            }
        }

        return $ashley_packages;
    }

    /**
     * Shipped Order Email
     * @param WebsiteOrder $order
     * @param Account $account
     * @return bool
     */
    public function shipped_order_email($order, $account) {

        $account_user = new User();
        $account_user->get( $account->user_id );

        $website_user = new WebsiteUser();
        $website_user->get( $order->website_user_id, $account->id );

        $message = file_get_contents( "http://{$account->domain}/shopping-cart/ashley-express-shipped-email/?woid={$order->id}" );

        return fn::mail(
            $website_user->email
            , "Order #{$order->id} ASN Notification"
            , $message
            , "noreply@blinkyblinky.me"
            , $account_user->email
            , false
        );

    }


}
