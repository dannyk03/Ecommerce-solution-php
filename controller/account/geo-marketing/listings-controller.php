<?php
/**
 * Created by PhpStorm.
 * User: gbrunacci
 * Date: 04/12/14
 * Time: 14:59
 */

class ListingsController extends BaseController {
    /**
     * Setup the base for creating template responses
     */
    public function __construct() {
        // Pass in the base for all the views
        parent::__construct();

        $this->title = _('Listings | GeoMarketing');
    }

    /**
     * Index
     * @return TemplateResponse
     */
    public function index() {
        $location = new WebsiteYextLocation();
        $location_list = $location->get_all( $this->user->account->id );

        $locations = [];
        foreach ( $location_list as $location ) {
            $locations[ $location->id ] = $location;
        }

        if ( !$locations ) {
            return new RedirectResponse( '/geo-marketing/locations' );
        }

        library('yext');
        YEXT::$base_service = '';  // Power Listing API doesn't need /customers/<cust_id> in the URL
        $yext = new YEXT( $this->user->account );
        $listings = $yext->get(
            'powerlistings/status'
            , [ 'customerId' => YEXT::$customer_id, 'locationIds' => array_keys( $locations ) ]
        )->statuses;

        // They were returnings Listings without Location ID
        // So we make sure they belong to an Account's location
        foreach ( $listings as $k => $l ) {
            if ( !isset( $locations[ $l->locationId ] ) ) {
                unset( $listings[$k] );
            }
        }

        $website_yext_listing = new WebsiteYextListing();
        $website_yext_listing->remove_by_account_id( $this->user->account->id );
        $website_yext_listing->insert_bulk( $listings, $this->user->account->id );

        $this->resources->javascript( 'geo-marketing/listings/index' );

        return $this->get_template_response( 'geo-marketing/listings/index' )
            ->menu_item('geo-marketing/listings')
            ->kb(153)
            ->set( compact( 'locations', 'listings' ) );
    }

    /**
     * List All
     * @return DataTableResponse
     */
    public function list_all() {
        $dt = new DataTableResponse( $this->user );

        $location = new WebsiteYextLocation();
        $location_list = $location->get_all( $this->user->account->id );

        $locations = [];
        foreach ( $location_list as $location ) {
            $locations[ $location->id ] = $location;
        }

        // Set Order by
        $dt->order_by( '`location_id`', '`site_id`', '`status`', '`url`' );
        $dt->search( array( '`location_id`' => false, '`site_id`' => false, '`status`' => false, '`url`' => false ) );

        $dt->add_where( " AND `website_id` = " . (int) $this->user->account->id );
        $location_id = $_SESSION['listings']['location-id'];
        if ( $location_id ) {
            $dt->add_where( " AND `location_id` = " . $_SESSION['listings']['location-id'] );
        }

        // Get Locations
        $listing = new WebsiteYextListing();
        $listings = $listing->list_all( $dt->get_variables() );
        $dt->set_row_count( $listing->count_all( $dt->get_count_variables() ) );

        $data = [];
        foreach ( $listings as $listing ) {

            if ( $listing->status == 'OPTED_OUT' ) {
                $action = '<a href="/geo-marketing/listings/opt-in/?locationIds=' . $listing->location_id . '&siteIds=' . $listing->site_id . '" confirm="Do you want to OPT IN this listing?">OPT-IN</a>';
            } else {
                $action = '<a href="/geo-marketing/listings/opt-out/?locationIds=' . $listing->location_id . '&siteIds=' . $listing->site_id . '" confirm="Do you wanto to OPT OUT this listing?">OPT-OUT</a>';
            }

            $data[] = [
                $locations[ $listing->location_id ]->name . '<br>' . $action
                , $listing->site_id
                , str_replace('_', ' ', $listing->status)
                , '<a href="'. $listing->url .'">'. $listing->url .'</a>'
            ];
        }

        $dt->set_data( $data );

        return $dt;
    }

    public function opt_in() {
        library('yext');
        YEXT::$base_service = '';  // Power Listing API doesn't need /customers/<cust_id> in the URL
        $yext = new YEXT( $this->user->account );
        $response = $yext->put(
            'powerlistings/status'
            , [
                'customerId' => YEXT::$customer_id
                , 'locationIds' => $_GET['locationIds']
                , 'siteIds' => $_GET['siteIds']
                , 'status' => 'OPTED_IN'
            ]
        );
        if ( isset( $response->errors ) ) {
            $this->notify('Your Listing could not be Opted In. ' . $response->errors[0]->message, false);
        } else {
            $this->notify( 'Listing successfully Opted In' );
        }

        return new RedirectResponse( '/geo-marketing/listings' );
    }

    public function opt_out() {
        library('yext');
        YEXT::$base_service = '';  // Power Listing API doesn't need /customers/<cust_id> in the URL
        $yext = new YEXT( $this->user->account );
        $response = $yext->put(
            'powerlistings/status'
            , [
                'customerId' => YEXT::$customer_id
                , 'locationIds' => $_GET['locationIds']
                , 'siteIds' => $_GET['siteIds']
                , 'status' => 'OPTED_OUT'
            ]
        );

        if ( isset( $response->errors ) ) {
            $this->notify('Your Listing could not be Opted Out. ' . $response->errors[0]->message, false);
        } else {
            $this->notify( 'Listing successfully Opted Out' );
        }
        return new RedirectResponse( '/geo-marketing/listings' );
    }

}
