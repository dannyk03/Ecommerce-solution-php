<?php
class SocialMediaAboutUs extends ActiveRecordBase {
    // The columns we will have access to
    public $sm_facebook_page_id, $fb_page_id, $website_page_id, $key, $content, $date_created;

    /**
     * Setup the account initial data
     */
    public function __construct() {
        parent::__construct( 'sm_about_us' );
    }

    /**
     * Get
     *
     * @param int $sm_facebook_page_id
     */
    public function get( $sm_facebook_page_id ) {
        $this->prepare(
            'SELECT `sm_facebook_page_id`, `website_page_id`, `fb_page_id`, `key`, `content` FROM `sm_about_us` WHERE `sm_facebook_page_id` = :sm_facebook_page_id'
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
            , 'website_page_id' => $this->website_page_id
            , 'key' => strip_tags($this->key)
            , 'date_created' => $this->date_created
        ), 'iiss' );
    }

    /**
     * Save
     */
    public function save() {
        $this->update( array(
            'content' => $this->content
        ), array(
            'sm_facebook_page_id' => $this->sm_facebook_page_id
        ), 's', 'i' );
    }
}