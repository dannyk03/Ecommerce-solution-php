<?php
class LogoutController extends BaseController {
    /**
     * Setup the base for creating template responses
     */
    public function __construct() {
        parent::__construct( );
    }

    /**
     * Logout Page
     *
     * @return RedirectResponse
     */
    protected function index() {
        remove_cookie( AUTH_COOKIE );
        return new RedirectResponse('/login/');
    }

    /**
     * Override login function
     * @return bool
     */
    protected function get_logged_in_user() {
        $this->user = new User();
        return true;
    }
}