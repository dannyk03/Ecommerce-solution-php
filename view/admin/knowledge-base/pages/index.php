<?php
/**
 * @package Grey Suit Retail
 * @page List Pages
 *
 * Declare the variables we have available from other sources
 * @var Resources $resources
 * @var Template $template
 * @var User $user
 * @var string $link
 */

echo $template->start( ucwords( $_GET['s'] ) . ' ' . _('Pages') . ' ' . $link, '../sidebar' );
?>

<table ajax="<?php echo url::add_query_arg( 'section', KnowledgeBaseCategory::SECTION_ADMIN, '/knowledge-base/pages/list-all/' ); ?>" perPage="30,50,100">
    <thead>
        <tr>
            <th width="45%" sort="1"><?php echo _('Page'); ?></th>
            <th width="55%"><?php echo _('Category'); ?></th>
        </tr>
    </thead>
    <tbody>
    </tbody>
</table>

<?php echo $template->end(); ?>