<?php
class ArticlesController extends BaseController {
    /**
     * Setup the base for creating template responses
     */
    public function __construct() {
        // Pass in the base for all the views
        parent::__construct();

        // Tell what is the base for all login
        $this->view_base = 'knowledge-base/articles/';
        $this->section = _('Knowledge Base');
    }

    /**
     * List
     *
     * @return TemplateResponse
     */
    protected function index() {
        $kb_section = ( KnowledgeBaseCategory::SECTION_ADMIN == $_GET['s'] ) ? KnowledgeBaseCategory::SECTION_ACCOUNT : KnowledgeBaseCategory::SECTION_ADMIN;
        $uc_section = ucwords( $kb_section );
        $link = '<a href="' . url::add_query_arg( 's', $kb_section, '/' . $this->view_base ) . '" class="small" title="' . $uc_section . '">(' . _('Switch to') . ' ' . $uc_section . ')</a>';

        return $this->get_template_response( 'index' )
            ->set( compact( 'link', 'kb_section' ) )
            ->select( 'articles', 'view' );
    }

    /**
     * Add/Edit a user
     *
     * @return TemplateResponse|RedirectResponse
     */
    protected function add_edit() {
        // Determine if we're adding or editing the user
        $kb_article_id = ( isset( $_GET['kbaid'] ) ) ? (int) $_GET['kbaid'] : false;

        // Initialize classes
        $kb_article = new KnowledgeBaseArticle();
        $kb_category = new KnowledgeBaseCategory( $_GET['s'] );
        $kb_page = new KnowledgeBasePage();

        // Get the user
        if ( $kb_article_id ) {
            $kb_article->get( $kb_article_id );
            $kb_category->get( $kb_article->kb_category_id );
            $section = $kb_category->section;
        } else {
            $section = $_GET['s'];
        }

        // Create new form table
        $ft = new FormTable( 'fAddEditArticle', url::add_query_arg( array( 's' => $_GET['s'], 'kbaid' => $kb_article->id ), '/knowledge-base/articles/add-edit/' ) );

        $ft->submit( ( $kb_article->id ) ? _('Save') : _('Add') );

        $ft->add_field( 'text', _('Title'), 'tTitle', $kb_article->title )
            ->attribute( 'maxlength', 200 )
            ->add_validation( 'req', _('The "Title" field is required') );

        $ft->add_field( 'text', _('Slug'), 'tSlug', $kb_article->slug )
            ->attribute( 'maxlength', 100 )
            ->add_validation( 'req', _('The "Slug" field is required') );

        $ft->add_field( 'textarea', _('Content'), 'taContent', $kb_article->content )
            ->attribute( 'rte', 1 );

        $sections = array(
            KnowledgeBaseCategory::SECTION_ADMIN => ucwords( KnowledgeBaseCategory::SECTION_ADMIN )
            , KnowledgeBaseCategory::SECTION_ACCOUNT => ucwords( KnowledgeBaseCategory::SECTION_ACCOUNT )
        );

        $ft->add_field( 'select', _('Section'), 'sSection', ucwords( $section ) )
            ->options( $sections );

        $categories = $kb_category->sort_by_hierarchy();
        $categories_array = array();

        foreach( $categories as $category ) {
            $categories_array[$category->id] = str_repeat( '&nbsp;', $category->depth * 5 ) . $category->name;
        }

        $ft->add_field( 'select', _('Category'), 'sCategory', $kb_article->kb_category_id )
            ->options( $categories_array )
            ->add_validation( 'req', _('The "Category" field is required') );

        $pages = $kb_page->get_by_category( $kb_article->kb_category_id );
        $pages_array = array();

        foreach( $pages as $page ) {
            $pages_array[$page->id] = $page->name;
        }

        $ft->add_field( 'select', _('Page'), 'sPage', $kb_article->kb_page_id )
            ->options( $pages_array );

        // Make sure it's posted and verified
        if ( $ft->posted() ) {
            // Update all the fields
            $kb_article->kb_category_id = $_POST['sCategory'];
            $kb_article->kb_page_id = $_POST['sPage'];
            $kb_article->user_id = $this->user->id;
            $kb_article->title = $_POST['tTitle'];
            $kb_article->slug = $_POST['tSlug'];
            $kb_article->content = $_POST['taContent'];
            $kb_article->status = KnowledgeBaseArticle::STATUS_PUBLISHED;

            // Update or create
            if ( $kb_article->id ) {
                $kb_article->save();
            } else {
                $kb_article->create();
            }

            $this->notify( _('Your Knowledge Base Article has been successfully created/saved!') );

            return new RedirectResponse( url::add_query_arg( 's', $_GET['s'], '/knowledge-base/articles/' ) );
        }

        $form = $ft->generate_form();

        $this->resources->javascript( 'knowledge-base/articles/add-edit' );

        // Get Page
        return $this->get_template_response( 'add-edit' )
            ->select( 'articles', 'add' )
            ->add_title( ( ( $kb_article->id ) ? _('Edit') : _('Add') ) . ' ' . _('Article') )
            ->set( compact( 'form' ) );
    }

    /***** AJAX *****/

    /**
     * List
     *
     * @return DataTableResponse
     */
    protected function list_all() {
        // Get response
        $dt = new DataTableResponse( $this->user );

        $kb_article = new KnowledgeBaseArticle();

        // Set Order by
        $dt->order_by( 'kba.`title`', 'category', 'page' );
        $dt->add_where( ' AND kbc.`section` = ' . $kb_article->quote( $_GET['section'] ) );
        $dt->add_where( ' AND ( kbc2.`section` = ' . $kb_article->quote( $_GET['section'] ) . ' OR kbc2.`section` IS NULL )' );
        $dt->search( array( 'kba.`title`' => false, 'kbc.`name`' => false, 'kbc2.`name`' => false, 'kbp.`name`' => false ) );

        // Get items
        $articles = $kb_article->list_all( $dt->get_variables() );
        $dt->set_row_count( $kb_article->count_all( $dt->get_count_variables() ) );

        // Set initial data
        $data = false;
        $confirm_delete = _('Are you sure you want to delete this article? This cannot be undone.');
        $delete_nonce = nonce::create( 'delete' );

        /**
         * @var KnowledgeBaseArticle $article
         */
        if ( is_array( $articles ) )
        foreach ( $articles as $article ) {
            $data[] = array(
                $article->title . '<div class="actions">' .
                    '<a href="' . url::add_query_arg( array( 's' => $_GET['section'], 'kbaid' => $article->id ), '/knowledge-base/articles/add-edit/' ) . '" title="' . $article->title . '">' . _('Edit') . '</a> | ' .
                    '<a href="' . url::add_query_arg( array( 'kbaid' => $article->id, '_nonce' => $delete_nonce ), '/knowledge-base/articles/delete/' ) . '" title="' . _('Delete') . '" ajax="1" confirm="' . $confirm_delete . '">' . _('Delete') . '</a></div>'
                , $article->category
                , $article->page
            );
        }

        // Send response
        $dt->set_data( $data );

        return $dt;
    }

    /**
     * Delete
     *
     * @return AjaxResponse
     */
    protected function delete() {
        // Verify the nonce
        $response = new AjaxResponse( $this->verified() );

        // If there is an error or now user id, return
        if ( $response->has_error() || !isset( $_GET['kbaid'] ) )
            return $response;

        // Get the article
        $kb_article = new KnowledgeBaseArticle();
        $kb_article->get( $_GET['kbaid'] );
        $kb_article->status = KnowledgeBaseArticle::STATUS_DELETED;
        $kb_article->save();

        // Redraw the table
        jQuery('.dt:first')->dataTable()->fnDraw();

        // Add the response
        $response->add_response( 'jquery', jQuery::getResponse() );

        return $response;
    }

    /**
     * Gets Categories
     *
     * @return AjaxResponse
     */
    protected function get_categories() {
        // Verify the nonce
        $response = new AjaxResponse( $this->verified() );

        // If there is an error or now user id, return
        if ( $response->has_error() || !isset( $_POST['s'] ) )
            return $response;

        // Get the user
        $kb_category = new KnowledgeBaseCategory($_POST['s'] );

        $categories = $kb_category->sort_by_hierarchy();
        $categories_array = array();

        foreach( $categories as $category ) {
            $categories_array[$category->id] = str_repeat( '&nbsp;', $category->depth * 5 ) . $category->name;
        }

         // Create new form table
        $ft = new FormTable( 'fAddEditArticle' );

        $html = $ft->add_field( 'select', _('Category'), 'sCategory' )
            ->options( $categories_array )
            ->generate();

        jQuery('#sCategory')->replaceWith( $html );

        // Add the response
        $response->add_response( 'jquery', jQuery::getResponse() );

        return $response;
    }

    /**
     * Gets Pages
     *
     * @return AjaxResponse
     */
    protected function get_pages() {
        // Verify the nonce
        $response = new AjaxResponse( $this->verified() );

        // If there is an error or now user id, return
        if ( $response->has_error() || !isset( $_POST['kbcid'] ) )
            return $response;

        // Get the user
        $kb_page = new KnowledgeBasePage();

        $pages = $kb_page->get_by_category( $_POST['kbcid'] );
        $pages_array[] = '-- ' . _('Select Page') . ' --';

        foreach( $pages as $page ) {
            $pages_array[$page->id] = $page->name;
        }

         // Create new form table
        $ft = new FormTable( 'fAddEditArticle' );
        $kb_page_id = ( isset( $_POST['kbpid'] ) ) ? $_POST['kbpid'] : 0;

        $html = $ft->add_field( 'select', _('Page'), 'sPage', $kb_page_id )
            ->options( $pages_array )
            ->generate();

        jQuery('#sPage')->replaceWith( $html );

        // Add the response
        $response->add_response( 'jquery', jQuery::getResponse() );

        return $response;
    }
}