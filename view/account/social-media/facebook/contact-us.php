<?php
/**
 * @package Grey Suit Retail
 * @page Contact Us | Facebook | Social Media
 *
 * Declare the variables we have available from other sources
 * @var Resources $resources
 * @var Template $template
 * @var User $user
 * @var SocialMediaFacebookPage $page
 * @var SocialMediaContactUs $contact_us
 */

echo $template->start( _('Contact Us') . ' - ' . $page->name, 'sidebar' );

if ( !$contact_us->fb_page_id ) {
    // Define instructions
    $instructions = array(
        1 => array(
            'title' => _('Go to the Contact Us application')
            , 'text' => _('Go to the') . ' <a href="http://apps.facebook.com/op-contact-us/" title="' . _('Online Platform - Contact Us') . '" target="_blank">' . _('Contact Us') . '</a> ' . _('application page') . '.'
            , 'image' => false
        )
        , 2 => array(
            'title' => _('Install The App')
            , 'text' => _('Click') . ' <strong>' . _('Install This App.') . '</strong> ' . _('on the page shown below:')
        )
        , 3 => array(
            'title' => _('Choose Your Page')
            , 'text' => _('(Note - You must first be an admin of the page to install the App)')
        )
        , 4 => array(
            'title' => _('Click Add Online Platform - Contact Us')
        )
        , 5 => array(
            'title' => _('Click on the Contact Us App')
            , 'text' => _("Scroll down below the banner, and you'll see your apps (you may need to click on the arrow on the right-hand side to find the app you're looking for) and click on the About Us")
        )
        , 6 => array(
            'title' => _('Click on the Update Settings')
        )
        , 7 => array(
            'title' => _('Click Add Online Platform - Contact Us')
            , 'text' => _('Copy and paste the connection code into the Facebook Connection Key box shown below (when done it will say Connected): ') . $contact_us->key
        )
    );

    foreach ( $instructions as $step => $data ) {
        echo '<h2 class="title">', _('Step'), " $step:", $data['title'], '</h2>';

        if ( isset( $data['text'] ) )
            echo '<p>', $data['text'], '</p>';

        if ( !isset( $data['image'] ) || $data['image'] != false )
            echo '<br /><p><a href="http://account.imagineretailer.com/images/social-media/facebook/contact-us/', $step, '.png"><img src="http://account.imagineretailer.com/images/social-media/facebook/contact-us/', $step, '.png" alt="', $data['title'], '" width="750" /></a></p>';

        echo '<br /><br />';
    }
 } else {
    ?>
    <p class="text-right"><a href="http://www.facebook.com/pages/ABC-Company/<?php echo $contact_us->fb_page_id; ?>?sk=app_245607595465926" title="<?php echo _('View Facebook Page'); ?>" target="_blank"><?php echo _('View Facebook Page'); ?></a></p>
    <?php
    if ( $user->account->pages ) {
        echo '<p>', _('Your app is currently active.'), '</p>';
    } else {
    ?>
    <form name="fContactUs" action="<?php echo url::add_query_arg( 'smfbpid', $page->id, '/social-media/facebook/contact-us/' ); ?>" method="post">
        <textarea name="taContent" id="taContent" cols="50" rows="3" rte="1"><?php echo $contact_us->content; ?></textarea>

        <p><a href="#dUploadFile" title="<?php echo _('Upload File (Media Manager)'); ?>" rel="dialog"><?php echo _('Upload File'); ?></a> | (<?php echo _('Image Width: 810px Image Height: 700px Max'); ?>)</p>
        <br /><br />

        <input type="submit" class="button" value="<?php echo _('Save'); ?>" />
        <?php nonce::field('contact_us'); ?>
    </form>
    <?php } ?>

    <div id="dUploadFile" class="hidden">
        <input type="text" class="tb" id="tFileName" placeholder="<?php echo _('Enter File Name'); ?>..." error="<?php echo _('You must type in a file name before uploading a file.'); ?>" />
        <a href="#" id="aUploadFile" class="button" title="<?php echo _('Upload'); ?>"><?php echo _('Browse'); ?></a>
        <a href="#" class="button loader hidden" id="upload-file-loader" title="<?php echo _('Loading'); ?>"><img src="/images/buttons/loader.gif" alt="<?php echo _('Loading'); ?>" /></a>
        <div class="hidden-fix position-absolute" id="upload-file"></div>
        <br /><br />

        <div id="file-list">
        <?php
        if ( empty( $files ) ) {
            echo '<p class="no-files">', _('You have not uploaded any files.') . '</p>';
        } else {
            // Set variables
            $delete_file_nonce = nonce::create('delete_file');
            $confirm = _('Are you sure you want to delete this file?');

            /**
             * @var AccountFile $file
             */
            foreach ( $files as $file ) {
                $file_name = f::name( $file->file_path );
                $extension = f::extension( $file->file_path );
                $date = new DateTime( $file->date_created );

                if ( in_array( $extension, image::$extensions ) ) {
                    // It's an image!
                    echo '<div id="file-' . $file->id . '" class="file"><a href="#', $file->file_path, '" id="aFile', $file->id, '" class="file img" title="', $file_name, '" rel="' . $date->format( 'F jS, Y') . '"><img src="' . $file->file_path . '" alt="' . $file_name . '" /></a><a href="' . url::add_query_arg( array( '_nonce' => $delete_file_nonce, 'afid' => $file->id ), '/website/delete-file/' ) . '" class="delete-file" title="' . _('Delete File') . '" ajax="1" confirm="' . $confirm . '"><img src="/images/icons/x.png" width="15" height="17" alt="' . _('Delete File') . '" /></a></div>';
                } else {
                    // It's not an image!
                    echo '<div id="file-' . $file->id . '" class="file"><a href="#', $file->file_path, '" id="aFile', $file->id, '" class="file" title="', $file_name, '" rel="' . $date->format( 'F jS, Y') . '"><img src="/images/icons/extensions/' . $extension . '.png" alt="' . $file_name . '" /><span>' . $file_name . '</span></a><a href="' . url::add_query_arg( array( '_nonce' => $delete_file_nonce, 'afid' => $file->id ), '/website/delete-file/' ) . '" class="delete-file" title="' . _('Delete File') . '" ajax="1" confirm="' . $confirm . '"><img src="/images/icons/x.png" width="15" height="17" alt="' . _('Delete File') . '" /></a></div>';
                }
            }
        }
        ?>
        </div>

        <br /><br />
        <div id="dCurrentLink" class="hidden">
            <p><strong><?php echo _('Current Link'); ?>:</strong></p>
            <p><input type="text" class="tb" id="tCurrentLink" value="<?php echo _('No link selected'); ?>" /></p>
            <br />
            <table class="col-1">
                <tr>
                    <td class="col-3"><strong><?php echo _('Date'); ?>:</strong></td>
                    <td class="col-3"><strong><?php echo _('Size'); ?>:</strong></td>
                    <td class="col-3">&nbsp;</td>
                </tr>
                <tr>
                    <td id="tdDate"></td>
                    <td id="tdSize"></td>
                    <td class="text-right"><a href="#" id="insert-into-post" class="button close"><?php echo _('Insert Into Post'); ?></a></td>
                </tr>
            </table>
        </div>
    </div>
    <?php nonce::field( 'upload_file', '_upload_file' ); ?>
<?php } ?>


<?php echo $template->end(); ?>