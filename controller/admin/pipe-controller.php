<?php
class PipeController extends BaseController {
    /**
     * Setup the base for creating template responses
     */
    public function __construct() {
        // Pass in the base for all the views
        parent::__construct();

        // Tell what is the base for all login
        $this->view_base = 'test/';
    }

    /**
     * Pipe emails
     *
     * @return HtmlResponse
     */
    protected function email() {
        library( 'email/rfc822-addresses' );
        library( 'email/mime-parser-class' );

        $email_content = file_get_contents( 'php://stdin' );

        // Create mime
        $mime = new mime_parser_class();
        $mime->ignore_syntax_errors = 1;

        $mime->Decode( array( 'Data' => $email_content ), $emails );
        $email = $emails[0];

        // Get data
        $subject = $email['Headers']['subject:'];
        $body = ( empty( $email['Body'] ) ) ? $email['Parts'][0]['Body'] : $email['Body'];
        $body = nl2br( substr( $body, 0, strpos( $body, '******************* Reply Above This Line *******************' ) ) );
        $ticket_id = (int) preg_replace( '/.*Ticket #([0-9]+).*/', '$1', $subject );

        // Get Ticket
        $ticket = new Ticket();
        $ticket->get( $ticket_id );

        // Get User
        $user = new User();
        $user->get( $ticket->assigned_to_user_id );

        // Create comment based on email
        $ticket_comment = new TicketComment();
        $ticket_comment->ticket_id = $ticket->id;
        $ticket_comment->user_id = $ticket->user_id;
        $ticket_comment->comment = $body;
        $ticket_comment->create();

        // Set email headers
        $headers  = 'MIME-Version: 1.0' . "\r\n";
        $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";

        // Additional headers
        $headers .= 'To: ' . $user->email . "\r\n";
        $headers .= 'From: ' . $user->company . ' Support <noreply@' . $user->domain . '>' . "\r\n";

        // Let assigned user know
        $ticket_url = url::add_query_arg( 'tid', $ticket->id, 'http://admin.' . $user->domain . '/tickets/ticket/' );
        mail( $user->email, "New Response on Ticket #{$ticket_id}", "<p>A new response from the client has been received. See message below:</p><p><strong>Original Message:</strong><br />" . $ticket->message . "</p><p><strong>Client Response:</strong><br />{$body}</p><p><a href='{$ticket_url}'>{$ticket_url}</a></p>", $headers );

        return new HtmlResponse( '' );
    }

    /**
     * Pipe deploy
     *
     * @return HtmlResponse
     */
    protected function deploy() {
        library( 'email/rfc822-addresses' );
        library( 'email/mime-parser-class' );

        $email_content = file_get_contents( 'php://stdin' );

        // Response
        $response = new HtmlResponse( '' );

        // Create mime
        $mime = new mime_parser_class();
        $mime->ignore_syntax_errors = 1;

        $mime->Decode( array( 'Data' => $email_content ), $emails );
        $email = $emails[0];

        // Get data
        list( $repo, $message ) = explode( ':', $email['Headers']['subject:'] );

        // If it wasn't passed, ignore it
        if ( 'passed.' != substr( $message, -7 ) )
            return $response;

        switch ( $repo ) {
            case 'KerryJones/Imagine-Retailer':
                if ( !stristr( $message, 'release-' ) )
                    return $response;

                $server = new Server();
                $servers = $server->get_all();

                foreach( $servers as $server ) {
                    // SSH Connection
                    $ssh_connection = ssh2_connect( Config::server('ip', $server->ip), 22 );
                    ssh2_auth_password( $ssh_connection, Config::server('username', $server->ip), Config::server('password', $server->ip) );

                    // Build
                    ssh2_exec( $ssh_connection, "phing -verbose -f /gsr/build/backend-testing/build.xml" );
                }
            break;

            case 'KerryJones/GSR-Site':
                if ( !stristr( $message, 'development' ) )
                    return $response;

                $server = new Server();
                $servers = $server->get_all();

                foreach( $servers as $server ) {
                    // SSH Connection
                    $ssh_connection = ssh2_connect( Config::server('ip', $server->ip), 22 );
                    ssh2_auth_password( $ssh_connection, Config::server('username', $server->ip), Config::server('password', $server->ip) );

                    // Build
                    ssh2_exec( $ssh_connection, "phing -verbose -f /gsr/build/gsr-site-testing/build.xml" );
                }
            break;

            default:
                return $response;
            break;
        }

        return $response;
    }

    /**
     * Pipe reaches
     *
     * @return HtmlResponse
     */
    protected function reach() {
        library( 'email/rfc822-addresses' );
        library( 'email/mime-parser-class' );

        $email_content = file_get_contents( 'php://stdin' );

        // Create mime
        $mime = new mime_parser_class();
        $mime->ignore_syntax_errors = 1;

        $mime->Decode( array( 'Data' => $email_content ), $emails );
        $email = $emails[0];

        // Get data
        $subject = $email['Headers']['subject:'];
        $body = ( empty( $email['Body'] ) ) ? $email['Parts'][0]['Body'] : $email['Body'];
        $body = nl2br( substr( $body, 0, strpos( $body, '******************* Reply Above This Line *******************' ) ) );
        $reach_id = (int) preg_replace( '/.*Reach #([0-9]+).*/', '$1', $subject );

        // Get Reach
        $reach = new WebsiteReach();
        $reach->get_by_id( $reach_id );

        // Get User
        $user = new User();
        $user->get( $reach->assigned_to_user_id );

        // Create comment based on email
        $reach_comment = new WebsiteReachComment();
        $reach_comment->website_reach_id = $reach->id;
        $reach_comment->website_user_id = $reach->website_user_id;
        $reach_comment->comment = $body;
        $reach_comment->create();

        // Set email headers
        $headers  = 'MIME-Version: 1.0' . "\r\n";
        $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";

        // Additional headers
        $headers .= 'To: ' . $user->email . "\r\n";
        $headers .= 'From: ' . $user->company . ' Support <noreply@' . $user->domain . '>' . "\r\n";

        // Let assigned user know
        $reach_url = url::add_query_arg( 'wrid', $reach->id, 'http://account.' . $user->domain . '/products/reaches/reach/' );
        mail( $user->email, "New Response on Reach #{$reach_id}", "<p>A new response from the customer has been received. See message below:</p><p><strong>Original Message:</strong><br />" . $reach->message . "</p><p><strong>Client Response:</strong><br />{$body}</p><p><a href='{$reach_url}'>{$reach_url}</a></p>", $headers );

        // We don't want any response -- including headers, to be sent out
        exit;

        return new HtmlResponse( '' );
    }

    /**
     * Pipe Note
     *
     * @return HtmlResponse
     */
    protected function note() {
        library( 'email/rfc822-addresses' );
        library( 'email/mime-parser-class' );

        $email_content = file_get_contents( 'php://stdin' );

        // Create mime
        $mime = new mime_parser_class();
        $mime->ignore_syntax_errors = 1;

        $mime->Decode( array( 'Data' => $email_content ), $emails );
        $email = $emails[0];

        // Get data
        $subject = $email['Headers']['subject:'];
        $from = $email['ExtractedAddresses']['from:'][0];
        $to = preg_replace( '/.+for ([^;]+).+/', '$1', $email['Headers']['received:'] );
        list( $username, $domain ) = explode ( '@', $to );
        list ( $username, $tag_domain ) = explode( '+', $username );

        $body = ( empty( $email['Body'] ) ) ? $email['Parts'][0]['Body'] : $email['Body'];
        $length = strpos( $body, '>> ' );
        $body = ( $length ) ? substr( $body, 0, $length ) : substr( $body, 0 );
        $body = nl2br( $body );

        // Get the first website
        $account = new Account();
        $account->get_by_domain( $tag_domain );

        if ( !$account->id ) {
            // Try variation one
            $tag_domain = str_replace( 'www.', '', $tag_domain );

            $account->get_by_domain( $tag_domain );

            if ( !$account->id ) {
                // Try variation two
                $tag_domain = preg_replace( '/(.+?)(?:\.[a-zA-Z]{2,4}){1,2}$/', '$1', $tag_domain );

                $account->get_by_domain( $tag_domain );

                if ( !$account->id )
                    exit;
            }
        }

        // Try to get the user that sent the email
        $user = new User( 'admin' == SUBDOMAIN );
        $user->get_by_email( $from['address'] );

        // Determine the user id
        if ( !$user->id ) {
            $contact_name = $from['name'];

            if ( empty( $contact_name ) )
                $contact_name = $from['address'];

            $user->contact_name = $contact_name;
            $user->email = $from['address'];
            $user->role = User::ROLE_AUTHORIZED_USER;

            // Create
            $user->create();

            // Set password
            $user->set_password( md5( microtime() ) );
        }

        // Create note
        $account_note = new AccountNote();
        $account_note->website_id = $account->id;
        $account_note->user_id = $user->id;
        $account_note->message = "<strong>Email:</strong> $subject<br /><br />$body";
        $account_note->create();

        // We don't want any response -- including headers, to be sent out
        exit;

        return new HtmlResponse( '' );
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