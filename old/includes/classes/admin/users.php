<?php
/**
 * Handles all the user information
 *
 * @package Grey Suit Retail
 * @since 1.0
 */
class Users extends Base_Class {
	/**
	 * Hold the user_id
	 *
	 * @since 1.0.0
	 * @var int
	 * @access public
	 */
	public $user_id = 0;
	
	/**
	 * Construct initializes data
	 */
	public function __construct() {
		// Need to load the parent constructor
		if ( !parent::__construct() )
			return false;
		
		// Find out if the user has a cookie set, if so, sign him or her in
		if ( get_cookie( SECURE_AUTH_COOKIE ) ) {
			$this->encrypted_email = get_cookie( SECURE_AUTH_COOKIE );
		} elseif ( get_cookie( AUTH_COOKIE ) ) {
			$this->encrypted_email = get_cookie( AUTH_COOKIE );
		}
		
		if ( !empty( $this->encrypted_email ) ) {
			global $user, $mc;
			
			$user = $mc->get( $this->encrypted_email );
			
			// If memcache didn't get anything, get it and then add it
			if ( !$user ) {
				$user = $this->get_user_by_email( security::decrypt( base64_decode( $this->encrypted_email ), security::hash( COOKIE_KEY, 'secure-auth' ) ), security::hash( COOKIE_KEY, 'secure-auth' ) );
				
				// If they're not an admin but in an admin section, send them to the login screen
				if ( $user['role'] <= 6 && ADMIN ) {
					$this->logout();
					login();
				}
				
				$mc->add( $this->encrypted_email, $user, 7200 ); // 2 hours
			}
		}
	}
	
	/**********************************/
	/********** USER SECTION **********/
	/**********************************/
	
	/**
	 * Get all information of the users
	 *
	 * @param string $where
	 * @param string $order_by
	 * @param string $limit
	 * @return array
	 */
	public function list_users( $where, $order_by, $limit ) {
		global $user;
		
		// If they are below 8, that means they are a partner
		if ( $user['role'] < 8 )
			$where = ( empty( $where ) ) ? ' AND a.`company_id` = ' . $user['company_id'] : $where . ' AND a.`company_id` = ' . $user['company_id'];
		
		// Get the users
		$users = $this->db->get_results( "SELECT a.`user_id`, a.`email`, a.`contact_name`, COALESCE( a.`work_phone`, a.`cell_phone`, b.`phone`,'') AS phone, a.`role`, COALESCE( b.`domain`, '' ) AS domain FROM `users` AS a LEFT JOIN `websites` AS b ON ( a.`user_id` = b.`user_id` ) WHERE a.`status` <> 0 $where GROUP BY a.`user_id` ORDER BY $order_by LIMIT $limit", ARRAY_A );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to list users.', __LINE__, __METHOD__ );
			return false;
		}
		
		return $users;
	}
	
	/**
	 * Count all the users
	 *
	 * @param string $where
	 * @return array
	 */
	public function count_users( $where ) {
		global $user;
		
		// If they are below 8, that means they are a partner
		if ( $user['role'] < 8 )
			$where = ( empty( $where ) ) ? ' AND a.`company_id` = ' . $user['company_id'] : $where . ' AND a.`company_id` = ' . $user['company_id'];
		
		// Get the user count
		$user_count = $this->db->get_var( "SELECT COUNT( a.`user_id` ) FROM `users` AS a LEFT JOIN ( SELECT `domain`, `user_id` FROM `websites` ) AS b ON ( a.`user_id` = b.`user_id` ) WHERE a.`status` <> 0 $where" );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to count users.', __LINE__, __METHOD__ );
			return false;
		}
		
		return $user_count;
	}

	/**
	 * Creates a new user
	 *
	 * @since 1.0.0
	 *
	 * @param int $company_id
	 * @param string $email
	 * @param string $password
	 * @param string $contact_name
	 * @param string $store_name
	 * @param int $role
	 * @return bool|int
	 */
	public function create( $company_id, $email, $password, $contact_name, $store_name, $role ) {
        if ( $user = $this->get_user_by_email( $email ) )
            return false;

		$this->db->insert( 'users', array( 'company_id' => $company_id, 'email' => $email, 'password' => md5( $password ), 'contact_name' => $contact_name, 'store_name' => $store_name, 'role' => $role, 'status' => 1, 'date_created' => dt::now() ), 'issssiis', true );

		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to create user.', __LINE__, __METHOD__ );
			return false;
		}
		
		return $this->db->insert_id;
	}

	/**
	 * Updates a user's arbitrary information (whatever is in the array)
	 *
	 * @since 1.0.0
	 *
	 * @param int $user_id used to identify the user
	 * @param array $information (assumes all to be strings)
	 * @return Response
	 */
	public function update_information( $user_id, $information ) {
		global $user;

        $old_user = $this->get_user( $user_id );
        // Check to see if they are changing their email
        if ( $old_user['email'] != $information['email'] ) {
            // We need to make sure another user doesn't already have this address
            $other_user = $this->db
                ->prepare( 'SELECT `user_id`, `status` FROM `users` WHERE `email` = ?', 's', $information['email'] )
                ->get_row('');

            if ( $this->db->errno() ) {
			    $this->_err( 'Failed to get other user.', __LINE__, __METHOD__ );
                return new Response( false, _('An error occurred while trying to update this user. Please contact a system administrator.') );
            }

            if ( $other_user ) {
                if ( $other_user['status'] == 0 ) {
                    $this->db->prepare( 'DELETE FROM `users` WHERE `user_id` = ? LIMIT 1', 'i', $other_user['user_id'] )->query('');

                    if ( $this->db->errno() ) {
                        $this->_err( 'Failed to delete other user.', __LINE__, __METHOD__ );
                        return new Response( false, _('An error occurred while trying to update this user. Please contact a system administrator.') );
                    }
                } else {
                    return new Response( false, _('This email is already taken.') );
                }
            }
        }

		if ( isset( $information['password'] ) )
			$information['password'] = md5( $information['password'] );
		
		$this->db->update( 'users', $information, array( 'user_id' => $user_id ), str_repeat( 's', count( $information ) ), 'i' );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to update information for user.', __LINE__, __METHOD__ );
            return new Response( false, _('An error occurred while trying to update this user. Please contact a system administrator.') );
		}
		
		// If it was this user, update it
		if ( $user['user_id'] == $user_id )
			$user = array_merge( $user, $information );
		
		return new Response( true );
	}
	
	/**
	 * Activates a user
	 *
	 * @since 1.0.0
	 *
	 * @param int $user_id used to identify the user
	 * @return bool|int
	 */
	public function activate( $user_id ) {
		$this->db->update( 'users', array( 'status' => 1 ), array( 'user_id' => $user_id, 'status' => -1 ), 'i', 'ii' );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to activate user.', __LINE__, __METHOD__ );
			return false;
		}
		
		return true;
	}

	/**
	 * Signs in a user and sets cookie
	 *
	 * @param string $email
	 * @return bool
	 */
	public function login( $email, $password, $remember_me ) {
		// Prepare the statement
		$user = $this->db->prepare( 'SELECT `user_id`, `company_id`, `email`, `contact_name`, `store_name`, `products`, `role` FROM `users` WHERE `role` > 5 AND `status` = 1 AND `email` = ? AND `password` = MD5(?)', 'ss', $email, $password )->get_row( '', ARRAY_A );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to sign in user.', __LINE__, __METHOD__ );
			return false;
		}
		
		// If no user was found, return false
		if ( !$user )
			return false;
		
		$expiration = ( $remember_me ) ? 1209600 : 172800; // Two Weeks : Two Days
		$auth_cookie = ( security::is_ssl() ) ? SECURE_AUTH_COOKIE : AUTH_COOKIE;
		set_cookie( $auth_cookie, base64_encode( security::encrypt( $email, security::hash( COOKIE_KEY, 'secure-auth' ) ) ), $expiration );
		
		// Record the login
		$this->record_login( $user['user_id'] );
		
		return $user;
	}
	
	/**
	 * Logs out
	 */
	public function logout() {
		global $mc;
		
		// Removing both of these cookies will destroy everything
		remove_cookie( AUTH_COOKIE );
		remove_cookie( SECURE_AUTH_COOKIE );
		
		$mc->delete( $this->encrypted_email );
	}

	/**
	 * Record Login Date/Time
	 *
	 * @param int $user_id
	 * @return bool
	 */
	private function record_login( $user_id ) {
		// Set the last login date to now
		$this->db->update( 'users', array( 'last_login' => dt::date('Y-m-d H:i:s') ), array( 'user_id' => $user_id ), 's', 'i' );
	
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to record login.', __LINE__, __METHOD__ );
			return false;
		}
		
		return true;
	}
	
	/**
	 * Forgot Your Password
	 *
	 * @param string $email user email
	 * @return int
	 */
	public function forgot_password( $email ) {
		// Get the user
		$user = $this->db->prepare( "SELECT `user_id`, `account_type_id`, CONCAT( `first_name`, ' ', `last_name` ) AS name, `status` FROM `users` WHERE `email` = ?", 's', $email )->get_row( '', ARRAY_A );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to get user data.', __LINE__, __METHOD__ );
			return false;
		}
		
		if ( $user ) {
			$e = new Emails();
			
			if ( -1 == $user['status'] ) {
				// This means their account was never activated, so send the same email
				$e->send_confirmation( $user['user_id'], $email );
				
				return 1;
			} else {
				// This means it is a legitimate forgot password request
				$e->reset_password( $user['user_id'], $user['name'], $email );
				
				return 2;
			}
		} else { 
			return 0;
		}
	}
	
	/**
	 * Finds out whether an email exists
	 *
	 * @param string $email
	 * @return bool|int
	 */
	public function email_exists( $email ) {
		// Prepare the statement
		$user_id = $this->db->prepare( 'SELECT `user_id` FROM `users` WHERE `email` = ?', 's', $email )->get_var('');
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to check if an email existed.', __LINE__, __METHOD__ );
			return false;
		}
		
		return $user_id;
	}
	
	/**
	 * Finds out whether a user exists
	 *
	 * @param int $user_id
	 * @return bool
	 */
	public function user_exists( $user_id ) {
		// Prepare the statement
		$date_created = $this->db->prepare( 'SELECT `date_created` FROM `users` WHERE `user_id` = ?', 'i', $user_id )->get_var('');
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to check if a user existed.', __LINE__, __METHOD__ );
			return false;
		}
		
		return ( empty( $date_created ) ) ? false : true;
	}
	
	/**
	 * Gets a user by their id
	 *
	 * @since 1.0.0
	 *
	 * @param int $user_id
	 * @return object|bool $user (object) if user is logged in, false if not logged in.
	 */
	public function get_user( $user_id ) {
        // Prepare the statement
        $user = $this->db->prepare( 'SELECT a.`user_id`, a.`company_id`, a.`email`, a.`contact_name`, a.`store_name`, a.`work_phone`, a.`cell_phone`, a.`billing_first_name`, a.`billing_last_name`, a.`billing_address1`, a.`billing_city`, a.`billing_state`, a.`billing_zip`, a.`products`, a.`role`, a.`status`, a.`date_created`, b.`name` AS company, b.`domain` FROM `users` AS a LEFT JOIN `companies` AS b ON ( a.`company_id` = b.`company_id` ) WHERE a.`user_id` = ?', 'i', $user_id )->get_row( '', ARRAY_A );

        // Handle any error
        if ( $this->db->errno() ) {
            $this->_err( 'Failed to get user.', __LINE__, __METHOD__ );
            return false;
        }

        $user['company'] = html_entity_decode( $user['company'], ENT_QUOTES );

		return $user;
	}
	
	/**
	 * Gets a bunch of users
	 *
	 * @param string $where
	 * @return array
	 */
	public function get_users( $where = '' ) {
		global $user;
		
		// Make sure they can only see what they're supposed to
		if ( $user['role'] < 8 )
			$where .= ' AND ( `company_id` = ' . (int) $user['company_id'] . ' OR `user_id` = 493 )';
		
		$users = $this->db->get_results( "SELECT `user_id`, `contact_name`, `email`, `role` FROM `users` WHERE `status` = 1 $where ORDER BY `contact_name`", ARRAY_A );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to get users.', __LINE__, __METHOD__ );
			return false;
		}
		
		return $users;
	}

    /**
	 * Gets all the "admin" users
	 *
	 * @param array $user_ids [optional] any additional user ids you want to be included
	 * @return array
	 */
	public function admin_users( $user_ids = array() ) {
		global $user;

        $user_ids[] = 493;
        $where = '';

        // Type Juggline
        foreach ( $user_ids as &$uid ) {
            $uid = (int) $uid;
        }

		// Make sure they can only see what they're supposed to
		if ( $user['role'] < 8 )
			$where .= ' AND ( `company_id` = ' . $user['company_id'] . ' OR `user_id` IN( ' . implode( ', ', $user_ids ) . ' ) ) ';

		$users = $this->db->get_results( "SELECT `user_id`, `contact_name`, `email`, `role` FROM `users` WHERE `status` = 1 AND `role` > 5 AND '' <> `contact_name` $where ORDER BY `contact_name`", ARRAY_A );

		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to get users.', __LINE__, __METHOD__ );
            return false;
		}

		return $users;
	}

	/** 
     * Gets the users that have created or modified a product
	 *
	 * @return array
	 */
	public function get_product_users() {
        global $user;

        // Make sure they can only see what they're supposed to
		$where = ( $user['role'] < 8 ) ? ' AND a.`company_id` = ' . (int) $user['company_id'] : '';

		$users = $this->db->get_results( "SELECT DISTINCT a.`user_id`, a.`contact_name` FROM `users` AS a INNER JOIN `products` AS b ON ( a.`user_id` = b.`user_id_created` || a.`user_id` = b.`user_id_modified` ) WHERE b.`publish_date` <> '0000-00-00 00:00:00' $where", ARRAY_A );

		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to get product users.', __LINE__, __METHOD__ );
			return false;
		}

		return $users;
	}

    /**
	 * Deactivates a user
	 *
	 * @param int $user_id
	 * @return bool
	 */
	public function delete( $user_id ) {
        // Prepare the statement
        $this->db->update( 'users', array( 'status' => 0 ), array( 'user_id' => $user_id ), 'i', 'i' );

        // Handle any error
        if ( $this->db->errno() ) {
            $this->_err( 'Failed to deactivate user.', __LINE__, __METHOD__ );
            return false;
        }

		return true;
	}

	/**
	 * Gets an inactive user by user_id
	 *
	 * @since 1.0.0
	 *
	 * @param int $user_id
	 * @return bool
	 */
	public function get_inactive_user( $user_id ) {
		// Prepare the statement and get the variable
		$row = $this->db->get_row( 'SELECT `user_id` FROM `users` WHERE `user_id` = ' . (int) $user_id . ' AND `status` = -1', ARRAY_A );

		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to get inactive user.', __LINE__, __METHOD__ );
			return false;
		}
		
		return ( $row['user_id'] ) ? true : false;
	}
	
	/**
	 * Gets an inactive user by their email
	 *
	 * @since 1.0.0
	 *
	 * @param string $email
	 * @return int|bool $user_id
	 */
	public function get_inactive_user_by_email( $email ) {
		// Prepare the statement and get the variable
		$user_id = $this->db->prepare( 'SELECT `user_id` FROM `users` WHERE `email` = ? AND `status` = -1', 's', $email )->get_var( '', ARRAY_A );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to get inactive user by email.', __LINE__, __METHOD__ );
			return false;
		}
		
		return $user_id;
	}
	
	/**
	 * Gets a user by their email address
	 *
	 * @since 1.0.0
	 *
	 * @param string $email the user's email address
	 * @param bool $assign_user_id (optional|true)
	 * @return object|bool $user (object) if user is logged in, false if not logged in.
	 */
	public function get_user_by_email( $email, $assign_user_id = true ) {
		// Prepare the statement
		$user = $this->db->prepare( 'SELECT `user_id`, `company_id`, `email`, `contact_name`, `store_name`, `products`, `role` FROM `users` WHERE `status` = 1 AND `email` = ?', 's', $email )->get_row( '', ARRAY_A );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to get user by email.', __LINE__, __METHOD__ );
			return false;
		}
		
		if ( $assign_user_id )
			$this->user_id = (int) $user['user_id'];
		
		return $user;
	}
	
	/*************************************/
	/********** OTHER FUNCTIONS **********/
	/*************************************/

	/**
	 * Autocomplete
	 * 
	 * Gets the data for an autocomplete request
	 *
	 * @param string $query
	 * @param string $field
	 * @return bool
	 */
	public function autocomplete( $query, $field ) {
		global $user;
		
		// Construct WHERE
		$where = ( $user['role'] < 8 ) ? ' AND `company_id` = ' . $user['company_id'] : '';

		// Get results
		$results = $this->db->prepare( "SELECT DISTINCT( `$field` ) FROM `users` WHERE `$field` LIKE ? $where ORDER BY `$field`", 's', $query . '%' )->get_results( '', ARRAY_A );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( 'Failed to get autocomplete entries.', __LINE__, __METHOD__ );
			return false;
		}
		
		return $results;
	}
	
	/**
	 * Sets a user's password
	 *
	 * @since 1.0.0
	 *
	 * @param string $password the new password
	 * @param int $user_id
	 * @return bool
	 */
	public function set_user_password( $password, $user_id ) {
		list( $salt, $hash ) = $this->hash_password( $password );
		
		$this->db->update( 'users', array( 'salt' => $salt, 'password' => $hash ), array( 'user_id' => $user_id ), array( '%s', '%s' ), array( '%d' ) );
		
		// Handle any error
		if ( $this->db->errno() ) {
			$this->_err( "Failed to update user's password.", __LINE__, __METHOD__ );
			return false;
		}
		
		return true;
	}
	
	/**
	 * Hashes a password and returns the random salt and hash
	 *
	 * @since 1.0
	 * @uses security::salt()
	 *
	 * @param string $password
	 * @return array( $salt, $hash )
	 */
	private function hash_password( $password ) {
		$salt = security::salt( $method, SECRET_KEY . microtime() . mt_rand( 0, 10000 ) );
		
		return array( $salt, hash( 'sha512', $salt . $password ) );
	}
	
	/**
	 * Checks to make sure a password matches
	 *
	 * @since 1.0
	 *
	 * @param string $password
	 * @param string $salt
	 * @param string $hash
	 * @return bool
	 */
	private function hash_password_check( $password, $salt, $hash ) {
		return ( hash( 'sha512', $salt . $password ) == $hash ) ? true : false;
	}
	
	/**
	 * Report an error
	 *
	 * Make the parent error function a little less complicated
	 *
	 * @param string $message the error message
	 * @param int $line (optional) the line number
	 * @param string $method (optional) the class method that is being called
	 */
	private function _err( $message, $line = 0, $method = '' ) {
		return $this->error( $message, $line, __FILE__, dirname(__FILE__), '', __CLASS__, $method );
	}
}