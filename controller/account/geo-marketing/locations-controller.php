<?php
/**
 * Created by PhpStorm.
 * User: gbrunacci
 * Date: 26/11/14
 * Time: 15:55
 */

class LocationsController extends BaseController {

    /**
     * Index
     * @return $this
     */
    public function index() {
        return $this->get_template_response( 'geo-marketing/locations/index' )
            ->menu_item('geo-marketing/locations/list');
    }

    /**
     * List All
     * @return DataTableResponse
     */
    public function list_all() {
        $dt = new DataTableResponse( $this->user );

        // Set Order by
        $dt->order_by( '`name`', '`address`', '`last_update`' );
        $dt->search( array( '`name`' => false, '`address`' => false ) );
        $dt->add_where( " AND `website_id` = " . (int) $this->user->account->id );

        // Get Locations
        $location = new WebsiteYextLocation();
        $locations = $location->list_all( $dt->get_variables() );
        $dt->set_row_count( $location->count_all( $dt->get_count_variables() ) );

        $delete_nonce = nonce::create( 'delete' );
        $data = [];
        foreach ( $locations as $location ) {
            $data[] = [
                $location->id .
                '<br><a href="/geo-marketing/locations/add-edit/?id=' . $location->id . '">Edit</a>
                <!-- | <a href="/geo-marketing/locations/delete/?id=' . $location->id . '&_nonce='.$delete_nonce.'" ajax="1" confirm="Do you want to Delete this Location? Cannot be Undone.">Delete</a> -->'
                , $location->name
                , $location->address
                , date("Y-m-d H:i:s")
            ];

        }

        $dt->set_data( $data );

        return $dt;
    }

    /**
     * Delete
     * @return AjaxResponse
     */
    public function delete() {
        $response = new AjaxResponse( $this->verified() );

        if ( $response->has_error() )
            return $response;

        $website_yext_location = new WebsiteYextLocation();
        $website_yext_location->get( $_GET['id'], $this->user->account->id );

        if ( $website_yext_location->id ) {
            library('yext');
            $yext = new YEXT( $this->user->account );
            $response = $yext->delete( "locations/{$_GET['id']}" );
            if ( isset( $response->errors ) ) {
                $response->notify( 'Your Location could not be deleted. ' . $response->errors[0]->message , false );
            } else {
                $website_yext_location->remove();
                $response->add_response( 'reload_datatable', 'reload_datatable' );
            }
        }

        return $response;
    }

    /**
     * Add Edit
     * @return TemplateResponse
     */
    public function add_edit() {

        library('yext');
        $yext = new YEXT( $this->user->account );

        $website_yext_location = new WebsiteYextLocation();
        $location = [];

        if ( isset( $_GET['id'] ) ) {
            $website_yext_location->get( $_GET['id'], $this->user->account->id );
            $location = (array) $yext->get( "locations/{$_GET['id']}" );
        }

        $form = new BootstrapForm( 'add-edit-location' );

        $form->add_field( 'hidden', 'id', $location['id'] );

        $form->add_field( 'text', 'Name', 'locationName', $location['locationName'] )
            ->add_validation( 'req', 'A Name is Required' );
        $form->add_field( 'text', 'Address Line 1', 'address', $location['address'] )
            ->add_validation( 'req', 'An Address is Required' );
//        $form->add_field( 'text', 'Address Line 2', 'address2', $location['address2'] );
//        $form->add_field( 'checkbox', 'Suppress Address', 'suppressAddress', $location['suppressAddress'] );
        $form->add_field( 'text', 'City', 'city', $location['city'] )
            ->add_validation( 'req', 'A City is Required' );
        $form->add_field( 'text', 'State', 'state', $location['state'] )
            ->add_validation( 'req', 'A State is Required' );
        $form->add_field( 'text', 'ZIP', 'zip', $location['zip'] )
            ->add_validation( 'req', 'A Valid ZIP is Required' )
            ->add_validation( 'num', 'A Valid ZIP is Required' )
            ->add_validation( 'zip', 'A Valid ZIP is Required' );
        $form->add_field( 'text', 'Phone', 'phone', $location['phone'] );
        $form->add_field( 'checkbox', 'Is Phone Tracked', 'isPhoneTracked', $location['isPhoneTracked'] );
        $form->add_field( 'text', 'Fax Phone', 'faxPhone', $location['faxPhone'] );
        $form->add_field( 'text', 'Mobile Phone', 'mobilePhone', $location['mobilePhone'] );
        $form->add_field( 'text', 'Toll Free Phone', 'tollFreePhone', $location['tollFreePhone'] );
        $form->add_field( 'text', 'TTY Phone', 'ttyPhone', $location['ttyPhone'] );
        // TODO: Get Cateogory IDs from YEXT
//        $form->add_field( 'select', 'Category', 'categories[]', $location['categories'] )
//            ->attribute( 'multiple', 'multiple' )
//            ->options( [] );
        $form->add_field( 'text', 'Special Offer', 'specialOffer', $location['specialOffer'] );
        $form->add_field( 'text', 'Special Offer URL', 'specialOfferUrl', $location['specialOfferUrl'] );
        $form->add_field( 'text', 'Website URL', 'websiteUrl', $location['websiteUrl'] );
        $form->add_field( 'text', 'Reservations URL', 'reservationsUrl', $location['reservationsUrls'] );
        $form->add_field( 'text', 'Hours', 'hours', $location['hours'] );
        $form->add_field( 'text', 'Additional Hours Text', 'additionalHoursText', $location['additionalHoursText'] );
        // TODO: Holiday Hour Arrays
        // $form->add_field( 'text', 'Holiday Hours', 'specialOffer', $location['specialOffer'] );
        $form->add_field( 'textarea', 'Description', 'description', $location['description'] )
            ->attribute( 'rte', '1' );
        $form->add_field( 'select', 'Payment Options', 'paymentOptions[]', $location['paymentOptions'] )
            ->attribute( 'multiple', 'multiple' )
            ->options( [
                'AMERICANEXPRESS' => 'American Express'
                ,'CASH' => 'Cash'
                ,'CHECK' => 'Check'
                ,'DINERSCLUB' => 'Diners Club'
                ,'DISCOVER' => 'Discover'
                ,'FINANCING' => 'Financing'
                ,'INVOICE' => 'Invoice'
                ,'MASTERCARD' => 'Mastercard'
                ,'TRAVELERSCHECK' => 'Travelers Check'
                ,'VISA' => 'Visa'
            ] );
        // TODO: Media Manager Field Type
        // $form->add_field( 'image', 'Logo', 'specialOffer', $location['specialOffer'] );
        $form->add_field( 'textarea', 'Video URLs (one per line)', 'videoUrls', is_array($location['videoUrls']) ? implode( "\n", $location['videoUrls'] ) : $location['videoUrls'] );
        $form->add_field( 'text', 'Twitter Handle', 'twitterHandle', $location['twitterHandle'] );
        $form->add_field( 'text', 'Facebook Page URL', 'facebookPageUrl', $location['facebookPageUrl'] );
        // TODO: Media Manager Field Type
        // $form->add_field( 'image', 'Facebook Cover Photo', 'specialOffer', $location['specialOffer'] );
        // $form->add_field( 'image', 'Facebook Profile Picture', 'specialOffer', $location['specialOffer'] );
        $form->add_field( 'text', 'Year Stabilished', 'yearEstabilished', $location['yearEstabilished'] );
//        $form->add_field( 'text', 'Display Latitude', 'displayLat', $location['displayLat'] );
//        $form->add_field( 'text', 'Display Longutude', 'displayLon', $location['displayLon'] );
//        $form->add_field( 'text', 'Routable Latitude', 'routableLat', $location['routableLat'] );
//        $form->add_field( 'text', 'Routable Longitude', 'routableLon', $location['routableLon'] );
        $form->add_field( 'textarea', 'Emails (one per line)', 'emails', $location['emails'] ? implode( "\n", $location['emails'] ) : '' );
        $form->add_field( 'textarea', 'Specialities (one per line)', 'specialities', $location['specialities'] ? implode( "\n", $location['specialities'] ) : '' );
        $form->add_field( 'textarea', 'Services (one per line)', 'services', $location['services'] ? implode( "\n", $location['services'] ) : '' );
        $form->add_field( 'textarea', 'Brands (one per line)', 'brands', $location['brands'] ? implode( "\n", $location['brands'] ) : '' );
        $form->add_field( 'textarea', 'Languages (one per line) ', 'languages', $location['languages'] ? implode( "\n", $location['languages'] ) : '' );
        $form->add_field( 'textarea', 'Keywords (one per line)', 'keywords', $location['keywords'] ? implode( "\n", $location['keywords'] ) : '' );
//        $form->add_field( 'textarea', 'Lists (one per line)', 'lists', $location['lists'] ? implode( "\n", $location['lists'] ) : '' );

        $form->add_field( 'checkbox', 'List top 100 products on location', 'synchronize-products', $website_yext_location->synchronize_products );

        if ( $form->posted() ) {

            $post = $_POST;

            $website_yext_location->synchronize_products = (int) isset( $post['synchronize-products'] );
            $website_yext_location->name = $post['locationName'];
            $website_yext_location->address = "{$post['address']}<br>{$post['city']}, {$post['state']} {$post['zip']}";
            $website_yext_location->website_id = $this->user->account->id;

            // remove unwanted fields
            unset( $post['_nonce'] );
            unset( $post['synchronize-products'] );
            if ( !$post['services'] ) {
                unset( $post['services'] );
            }
            if ( !$post['brands'] ) {
                unset( $post['brands'] );
            }
            if ( !$post['languages'] ) {
                unset( $post['languages'] );
            }
            if ( !$post['keywords'] ) {
                unset( $post['keywords'] );
            }

            // TODO: Get from Config
            $post['categoryIds'] = [ 1963 ];

            if ( !$website_yext_location->id ) {
                // Create
                $website_yext_location->create();
                $post['id'] = $website_yext_location->id;
                $response = $yext->post( 'locations', $post );
                if ( isset( $response->errors ) ) {
                    $this->notify( 'Your Location could not be created. ' . $response->errors[0]->message , false );
                    $website_yext_location->remove();
                }
            } else {
                // Update
                $website_yext_location->save();
                $response = $yext->put( "locations/{$website_yext_location->id}", $post );
                if ( isset( $response->errors ) ) {
                    $this->notify( 'Your Location could not be updated. ' . $response->errors[0]->message , false );
                }
            }
            return new RedirectResponse( '/geo-marketing/locations' );

        }

        $form_html = $form->generate_form();

        return $this->get_template_response( 'geo-marketing/locations/add-edit' )
            ->menu_item('geo-marketing/locations/add-edit')
            ->set( compact( 'form_html' ) );
    }

} 