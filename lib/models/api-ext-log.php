<?php
class ApiExtLog extends ActiveRecordBase {
    // The columns we will have access to
    public $id, $website_id, $api, $method, $url, $request, $raw_request, $response, $raw_response, $date_created;

    /**
     * Setup the account initial data
     */
    public function __construct() {
        parent::__construct( 'api_ext_log' );
    }

    /**
     * Create
     */
    public function create() {
        $this->date_created = dt::now();

        $this->id = $this->insert( array(
            'website_id' => $this->website_id
            , 'api' => $this->api
            , 'method' => $this->method
            , 'url' => $this->url
            , 'request' => $this->request
            , 'raw_request' => $this->raw_request
            , 'response' => $this->response
            , 'raw_response' => $this->raw_response
            , 'date_created' => $this->date_created
        ), 'issssssss' );
    }
}