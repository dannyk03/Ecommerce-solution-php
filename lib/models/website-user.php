<?php
class WebsiteUser extends ActiveRecordBase {
    // The columns we will have access to
    public $id, $website_user_id, $website_id, $email, $password, $billing_first_name, $billing_last_name
        , $billing_address1, $billing_address2, $billing_city, $billing_state, $billing_zip, $billing_phone
        , $billing_alt_phone, $shipping_first_name, $shipping_last_name, $shipping_address1, $shipping_address2
        , $shipping_city, $shipping_state, $shipping_zip, $status, $date_registered;

    /**
     * Setup the account initial data
     */
    public function __construct() {
        parent::__construct( 'website_users' );

        // We want to make sure they match
        if ( isset( $this->website_user_id ) )
            $this->id = $this->website_user_id;
    }

    /**
     * Get
     *
     * @param int $website_user_id
     * @param int $account_id
     */
    public function get( $website_user_id, $account_id ) {
        $this->prepare(
            'SELECT `website_user_id`, `email`, `billing_first_name`, `billing_last_name`, `billing_address1`, `billing_address2`, `billing_city`, `billing_state`, `billing_phone`, `billing_alt_phone`, `billing_zip`, `shipping_first_name`, `shipping_last_name`, `shipping_address1`, `shipping_address2`, `shipping_city`, `shipping_state`, `shipping_zip`, `status`, `date_registered` FROM `website_users` WHERE `website_user_id` = :website_user_id AND `website_id` = :account_id'
            , 'ii'
            , array( ':website_user_id' => $website_user_id, ':account_id' => $account_id )
        )->get_row( PDO::FETCH_INTO, $this );

        $this->id = $this->website_user_id;
    }

    /**
     * Get by email
     *
     * @param string $email
     * @param int $account_id
     */
    public function get_by_email( $email, $account_id ) {
        $this->prepare(
            'SELECT `website_user_id`, `email`, `billing_first_name`, `billing_last_name`, `billing_address1`, `billing_address2`, `billing_city`, `billing_state`, `billing_phone`, `billing_alt_phone`, `billing_zip`, `shipping_first_name`, `shipping_last_name`, `shipping_address1`, `shipping_address2`, `shipping_city`, `shipping_state`, `shipping_zip`, `status`, `date_registered` FROM `website_users` WHERE `website_id` = :account_id AND `email` = :email'
            , 'is'
            , array( ':account_id' => $account_id, ':email' => $email )
        )->get_row( PDO::FETCH_INTO, $this );

        $this->id = $this->website_user_id;
    }

    /**
     * Update the user
     */
    public function save() {
        parent::update( array(
            'email' => strip_tags($this->email)
            , 'billing_first_name' => strip_tags($this->billing_first_name)
            , 'billing_last_name' => strip_tags($this->billing_last_name)
            , 'billing_address1' => strip_tags($this->billing_address1)
            , 'billing_address2' => strip_tags($this->billing_address2)
            , 'billing_city' => strip_tags($this->billing_city)
            , 'billing_state' => strip_tags($this->billing_state)
            , 'billing_zip' => strip_tags($this->billing_zip)
            , 'billing_phone' => strip_tags($this->billing_phone)
            , 'billing_alt_phone' => strip_tags($this->billing_alt_phone)
            , 'shipping_first_name' => strip_tags($this->shipping_first_name)
            , 'shipping_last_name' => strip_tags($this->shipping_last_name)
            , 'shipping_address1' => strip_tags($this->shipping_address1)
            , 'shipping_address2' => strip_tags($this->shipping_address2)
            , 'shipping_city' => strip_tags($this->shipping_city)
            , 'shipping_state' => strip_tags($this->shipping_state)
            , 'shipping_zip' => strip_tags($this->shipping_zip)
            , 'status' => $this->status
        ), array( 'website_user_id' => $this->id )
            , 'sssssssssssssssssi', 'i'
        );
    }

    /**
     * Set Password
     *
     * @param string $password
     */
    public function set_password( $password ) {
        $this->update( array(
            'password' => md5( $password )
        ), array(
            'website_user_id' => $this->id
        ), 's', 'i' );
    }

    /**
     * Remove
     */
    public function remove() {
        $this->delete( array(
            'website_user_id' => $this->id
        ), 'i' );
    }

    /**
	 * List Users
	 *
	 * @param $variables array( $where, $order_by, $limit )
	 * @return WebsiteUser[]
	 */
	public function list_all( $variables ) {
        // Get the variables
		list( $where, $values, $order_by, $limit ) = $variables;

        return $this->prepare(
            "SELECT `website_user_id`, `email`, `billing_first_name`, `date_registered` FROM `website_users` WHERE 1 $where $order_by LIMIT $limit"
            , str_repeat( 's', count( $values ) )
            , $values
        )->get_results( PDO::FETCH_CLASS, 'WebsiteUser' );
	}

    /**
	 * Count all
	 *
	 * @param array $variables
	 * @return int
	 */
	public function count_all( $variables ) {
        // Get the variables
		list( $where, $values ) = $variables;

		// Get the website count
        return $this->prepare( "SELECT COUNT( `website_user_id` )  FROM `website_users` WHERE 1 $where"
            , str_repeat( 's', count( $values ) )
            , $values
        )->get_var();
	}

    /**
     * Get By Account
     * @param $account_id
     * @return WebsiteUser[]
     */
    public function get_by_account( $account_id ) {
        return $this->prepare(
            "SELECT * FROM `website_users` WHERE website_id = :account_id"
            , 'i'
            , [ ':account_id' => $account_id ]
        )->get_results( PDO::FETCH_CLASS, 'WebsiteUser' );
    }
}
