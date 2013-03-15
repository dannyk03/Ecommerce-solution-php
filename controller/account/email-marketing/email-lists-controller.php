<?php
class EmailListsController extends BaseController {
    /**
     * Setup the base for creating template responses
     */
    public function __construct() {
        // Pass in the base for all the views
        parent::__construct();

        $this->view_base = 'email-marketing/email-lists/';
        $this->section = 'email-marketing';
        $this->title = _('Email Lists') . ' | ' . _('Email Marketing');
    }

    /**
     * List Subscribers
     *
     * @return TemplateResponse|RedirectResponse
     */
    protected function index() {
        if ( !$this->user->account->email_marketing )
            return new RedirectResponse('/email-marketing/subscribers/');

        return $this->get_template_response( 'index' )
            ->add_title( _('Email Lists') )
            ->select( 'email-lists' );
    }

    /**
     * Add/Edit
     *
     * @return TemplateResponse|RedirectResponse
     */
    protected function add_edit() {
        // Get Coupon
        $email_list = new EmailList();

        $email_list_id = ( isset( $_GET['elid'] ) ) ? $_GET['elid'] : false;

        if ( $email_list_id )
            $email_list->get( $email_list_id, $this->user->account->id );

        $form = new FormTable( 'fAddEditEmailList' );

        if ( !$email_list->id )
            $form->submit( _('Create') );

        $form->add_field( 'text', _('Name'), 'tName', $email_list->name )
            ->attribute( 'maxlength', 80 )
            ->add_validation( 'req', _('The "Name" field is required') );

        $form->add_field( 'textarea', _('Description'), 'taDescription', $email_list->name );

        if ( $form->posted() ) {
            $success = true;

            // Get mailchimp
            library( 'MCAPI' );
            $mc = new MCAPI( Config::key('mc-api') );

            $original_name = $email_list->name;
            $email_list->name = $_POST['tName'];
            $email_list->description = $_POST['taDescription'];

            if ( $email_list->id ) {
                $mc->listInterestGroupUpdate( $this->user->account->mc_list_id, $original_name, $email_list->name );

                // Handle any error, but don't stop
                if ( $mc->errorCode ) {
                    $this->notify( $mc->errorMessage, false );
                    $success = false;
                } else {
                    $email_list->save();
                }
            } else {
                $mc->listInterestGroupAdd( $this->user->account->mc_list_id, $email_list->name );

                // Handle any error, but don't stop
                if ( $mc->errorCode ) {
                    $success = false;
                    $this->notify( $mc->errorMessage, false );
                } else {
                    $email_list->website_id = $this->user->account->id;
                    $email_list->create();
                }
            }

            if ( $success ) {
                $this->notify( _('Your email list has been added/updated successfully!') );
                return new RedirectResponse('/email-marketing/email-lists/');
            }
        }

        $form = $form->generate_form();
        $title = ( $email_list->id ) ? _('Edit') : _('Add');

        return $this->get_template_response( 'add-edit' )
            ->select( 'email-lists', 'add-edit' )
            ->add_title( $title . ' ' . _('Email List') )
            ->set( compact( 'email_list', 'form' ) );
    }

    /***** AJAX *****/

    /**
     * List All
     *
     * @return DataTableResponse
     */
    protected function list_all() {
        // Get response
        $dt = new DataTableResponse( $this->user );

        $email_list = new EmailList();

        // Set Order by
        $dt->order_by( 'el.`name`', 'el.`description`', 'el.`date_created`' );
        $dt->add_where( ' AND el.`website_id` = ' . (int) $this->user->account->id );
        $dt->search( array( 'el.`name`' => false, 'el.`description`' => true ) );

        // Get items
        $email_lists = $email_list->list_all( $dt->get_variables() );
        $dt->set_row_count( $email_list->count_all( $dt->get_count_variables() ) );

        // Set initial data
        $data = false;
        $confirm = _('Are you sure you want to delete this email list? This cannot be undone.');
        $delete_nonce = nonce::create( 'delete' );

        /**
         * @var EmailList $el
         */
        if ( is_array( $email_lists ) )
        foreach ( $email_lists as $el ) {
            // Make the delete text
            $delete = ( 'Default' == $el->name ) ? '' : ' | <a href="' . url ::add_query_arg( array( 'elid' => $el->id, '_nonce' => $delete_nonce ), '/email-marketing/email-lists/delete/' ) . '" title="' . _('Delete') . '" ajax="1" confirm="' . $confirm . '">' . _('Delete') . '</a></div>';

            $date = new DateTime( $el->date_created );

            $data[] = array(
                $el->name . ' (' . $el->count . ')<br /><div class="actions"><a href="' . url::add_query_arg( 'elid', $el->id, '/email-marketing/subscribers/' ) . '" title="' . _('View Subscribers') . '">' . _('View Subscribers') . '</a> | ' .
                    '<a href="' . url::add_query_arg( 'elid', $el->id, '/email-marketing/email-lists/add-edit/' ) . '" title="' . _('Edit') . '">' . _('Edit') . '</a>' . $delete
                , format::limit_chars( $el->description, 32, '...' )
                , $date->format( 'F jS, Y g:i a' )
            );
        }

        // Send response
        $dt->set_data( $data );

        return $dt;
    }

    /**
     * Delete
     *
     * @return AjaxResponse
     */
    protected function delete() {
        // Make sure it's a valid ajax call
        $response = new AjaxResponse( $this->verified() );

        // Make sure we have everything right
        $response->check( isset( $_GET['elid'] ), _('You cannot delete this email list') );

        if ( $response->has_error() )
            return $response;

        // Remove
        $email_list = new EmailList();
        $email_list->get( $_GET['elid'], $this->user->account->id );
        $email_list->remove_all( $this->user->account );

        // Redraw the table
        jQuery('.dt:first')->dataTable()->fnDraw();

        $response->add_response( 'jquery', jQuery::getResponse() );

        return $response;
    }
}