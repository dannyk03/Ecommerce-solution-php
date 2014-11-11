// When the page has loaded
head.load( 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js', function() {
    // Make the sections sortable
	$('#checklist-sections').sortable({
		items		: '.section'
		, cancel		: 'input'
        , cursor      : 'move'
		, placeholder	: 'section-placeholder'
        , forceHelperSize : true
		, forcePlaceholderSize : true
        , handle : 'a.handle'
	}).on( 'click', 'a.remove-section', function() {
        if ( $(this).parent().find('div.section-items:first .item:first').is('div') ) {
            alert( $(this).attr('err') );
            return;
        }

        if ( !confirm( $(this).attr('confirm') ) )
            return false;

        $(this).parent().remove();
    }).on( 'click', 'a.remove-item', function() {
        if ( !confirm( $(this).attr('confirm') ) )
            return false;

        $(this).parent().remove();
    });

    // Make the section items sortable
    $('.section').sortable({
		items		: '.item'
		, cancel		: 'input'
        , cursor      : 'move'
		, placeholder	: 'item-placeholder'
		, forcePlaceholderSize : true
        , handle : 'a.handle'
	});
});