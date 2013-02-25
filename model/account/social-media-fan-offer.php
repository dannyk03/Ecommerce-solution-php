<?php
class SocialMediaFanOffer extends ActiveRecordBase {
    // The columns we will have access to
    public $sm_facebook_page_id, $fb_page_id, $email_list_id, $key, $before, $after, $start_date, $end_date
        , $share_title, $share_image_url, $share_text, $date_created;

    /**
     * Setup the account initial data
     */
    public function __construct() {
        parent::__construct( 'sm_fan_offer' );
    }

    /**
     * Get
     *
     * @param int $sm_facebook_page_id
     */
    public function get( $sm_facebook_page_id ) {
        $this->prepare(
            'SELECT * FROM `sm_fan_offer` WHERE `sm_facebook_page_id` = :sm_facebook_page_id'
            , 'i'
            , array( ':sm_facebook_page_id' => $sm_facebook_page_id )
        )->get_row( PDO::FETCH_INTO, $this );
    }

    /**
     * Create
     */
    public function create() {
        $this->date_created = dt::now();

        $this->insert( array(
            'sm_facebook_page_id' => $this->sm_facebook_page_id
            , 'key' => $this->key
            , 'date_created' => $this->date_created
        ), 'iiss' );
    }

    /**
     * Save
     */
    public function save() {
        $this->update( array(
            'email_list_id' => $this->email_list_id
            , 'before' => $this->before
            , 'after' => $this->after
            , 'start_date' => $this->start_date
            , 'end_date' => $this->end_date
            , 'share_title' => $this->share_title
            , 'share_image_url' => $this->share_image_url
            , 'share_text' => $this->share_text
        ), array(
            'sm_facebook_page_id' => $this->sm_facebook_page_id
        ), 'isssssss', 'i' );
    }
}