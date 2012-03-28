<?php
/**
 * @page List Mobile Lists
 * @package Grey Suit Retail
 */

// Get current user
global $user;

// If user is not logged in
if ( !$user )
	login();

// Redirect to main section if they don't have mobile marketing
// Secure the section
if ( !$user['website']['mobile_marketing'] )
    url::redirect('/');

$m = new Mobile_Marketing();
$m->sync_subscribers_by_lists();

$selected = "mobile_marketing";
$title = _('Mobile Lists') . ' | ' . _('Mobile Marketing') . ' | ' . TITLE;
get_header();
?>

<div id="content">
	<h1><?php echo _('Mobile Lists'); ?></h1>
	<br clear="all" /><br />
	<?php get_sidebar( 'mobile-marketing/', 'mobile_lists' ); ?>
	<div id="subcontent">
		<table ajax="/ajax/mobile-marketing/lists/list/" perPage="100,250,500" cellpadding="0" cellspacing="0" width="100%">
			<thead>
				<tr>
					<th width="50%" sort="2"><?php echo _('Name'); ?></th>
					<th width="30%" sort="1"><?php echo _('Type'); ?></th>
					<th width="20%"><?php echo _('Date Created'); ?></th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
	<br /><br />
</div>

<?php get_footer(); ?>