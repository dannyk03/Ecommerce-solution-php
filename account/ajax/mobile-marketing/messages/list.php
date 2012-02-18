<?php
/**
 * @page List Mobile Messages
 * @package Imagine Retailer
 * @subpackage Account
 */

// Instantiate classes
$m = new Mobile_Marketing;
$dt = new Data_Table();

// Set variables
$dt->order_by( '`message`', '`status`', 'date_sent' );
$dt->add_where( " AND `website_id` = " . (int) $user['website']['website_id'] );
$dt->search( array( '`message`' => true ) );

// Get messages
$messages = $m->list_messages( $dt->get_variables() );
$dt->set_row_count( $m->count_messages( $dt->get_where() ) );

$confirm = _('Are you sure you want to delete this message? This cannot be undone.');
$delete_mobile_message_nonce = nonce::create( 'delete-mobile-message' );
$statuses = array( 'Draft', 'Scheduled', 'Sent' );

// Initialize variable
$data = array();

// Create output
if ( is_array( $messages ) )
foreach ( $messages as $m ) {
	if ( $m['status'] < 2 ) {
		$actions = '<a href="/mobile-marketing/messages/add-edit/?mmid=' . $m['mobile_message_id'] . '" title="' . _('Edit Message') . '">' . _('Edit') . '</a> | ';
		$actions .= '<a href="/ajax/mobile-marketing/messages/delete/?mmid=' . $m['mobile_message_id'] . '&amp;_nonce=' . $delete_mobile_message_nonce . '" title="' . _('Delete Message') . '" ajax="1" confirm="' . $confirm . '">' . _('Delete') . '</a>';
	} else {
		$actions = '<a href="/analytics/mobile-message/?mmid=' . $m['mobile_message_id'] . '" title="' . _('View Analytics') . '">' . _('Analytics') . '</a>';
	}
	
	$data[] = array( 
		format::limit_chars( $m['message'], 50, '...' ) . '<br /><div class="actions">' . $actions . '</div>',
		$statuses[$m['status']],
		dt::date( 'F jS, Y g:i a', $m['date_sent'] )
	);
}

// Send response
echo $dt->get_response( $data );