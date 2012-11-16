<?php
/**
 * @page Autoresponders
 * @package Grey Suit Retail
 */

// Get current user
global $user;

// If user is not logged in
if ( !$user )
	login();

$selected = "email_marketing";
$title = _('Autoresponders | Email Marketing') . ' | ' . TITLE;
get_header();
?>

<div id="content">
	<h1><?php echo _('Autoresponders'); ?></h1>
	<br clear="all" /><br />
	<?php get_sidebar( 'email-marketing/', 'autoresponders' ); ?>
	<div id="subcontent">
		<table cellpadding="0" cellspacing="0" width="100%" perPage="100,250,500" ajax="/ajax/email-marketing/autoresponders/list/">
			<thead>
				<tr>
					<th width="50%" sort="1"><?php echo _('Name'); ?></th>
					<th width="50%"><?php echo _('Subject'); ?></th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
	<br /><br />
</div>

<?php get_footer(); ?>