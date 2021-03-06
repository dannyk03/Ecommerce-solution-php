<?php
class Company extends ActiveRecordBase {
    // The columns we will have access to
    public $id, $company_id, $name, $domain, $email, $less, $css, $date_created;

    /**
     * Setup the account initial data
     */
    public function __construct() {
        parent::__construct( 'companies' );

        // We want to make sure they match
        if ( isset( $this->company_id ) )
            $this->id = $this->company_id;
    }

    /**
     * Get the company
     *
     * @param int $company_id
     */
    public function get( $company_id ) {
        $this->prepare( 'SELECT `company_id`, `name`, `domain`, `email`, `less`, `css` FROM `companies` WHERE `company_id` = :company_id', 'i', array( ':company_id' => $company_id ) )->get_row( PDO::FETCH_INTO, $this );

        $this->id = $this->company_id;
    }

    /**
     * Get all the companies
     *
     * @param int $style [optional]
     * @return array
     */
    public function get_all( $style = PDO::FETCH_CLASS ) {
        $class = ( PDO::FETCH_CLASS == $style ) ? 'Company' : NULL;

        return $this->get_results( 'SELECT `company_id`, `name` FROM `companies`', $style, $class );
    }

    /**
     * Create a company
     */
    public function create() {
        $this->date_created = dt::now();

        $this->insert( array(
            'name' => strip_tags($this->name)
            , 'domain' => strip_tags($this->domain)
            , 'email' => strip_tags($this->email)
            , 'date_created' => $this->date_created
        ), 'ssss' );

        $this->company_id = $this->id = $this->get_insert_id();
    }

    /**
     * Update the company
     */
    public function save() {
        parent::update( array(
            'name' => strip_tags($this->name)
            , 'domain' => strip_tags($this->domain)
            , 'email' => strip_tags($this->email)
            , 'less' => $this->less
            , 'css' => $this->css
        ), array( 'company_id' => $this->id ), 'sssss', 'i' );
    }

    /**
	 * Get all information of the websites
	 *
     * @param array $variables ( string $where, array $values, string $order_by, int $limit )
	 * @return array
	 */
	public function list_all( $variables ) {
		// Get the variables
		list( $where, $values, $order_by, $limit ) = $variables;

        $companies = $this->prepare(
            "SELECT `company_id`, `name`, `domain`, `date_created` FROM `companies` WHERE `status` = 1 $where $order_by LIMIT $limit"
            , str_repeat( 's', count( $values ) )
            , $values
        )->get_results( PDO::FETCH_CLASS, 'Company' );

		return $companies;
	}

	/**
	 * Count all the companies
	 *
	 * @param array $variables
	 * @return int
	 */
	public function count_all( $variables ) {
        // Get the variables
		list( $where, $values ) = $variables;

        $count = $this->prepare(
            "SELECT COUNT( `company_id` ) FROM `companies` WHERE `status` = 1 $where"
            , str_repeat( 's', count( $values ) )
            , $values
        )->get_var();

		return $count;
	}

    /**
     * Get Current Company
     * @return Company
     */
    public static function get_current_company() {
        $company = new Company();
        $company->get( COMPANY_ID );
        return $company;
    }
}
