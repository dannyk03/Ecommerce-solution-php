<?php
/**
 * Front to Grey Suit Retail. This file doesn't do anything, but loads
 * load.php which does and tells RS what to do next.
 *
 * Be aware that the Studio98 Framework is included by default
 *
 * @package Grey Suit Retail
 */

// This is not a cron job
define( 'CRON', false );

// Loads the setup process for the whole website
require_once( './load.php' );