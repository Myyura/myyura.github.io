$( document ).ready(function() {

	/* Sidebar height set */
	$('.sidebar').css('min-height',$(document).height());

	/* Secondary contact links */
	var scontacts = $('#contact-list-secondary');
	var contact_list = $('#contact-list');
	
	scontacts.hide();
	
	contact_list.mouseenter(function(){ scontacts.fadeIn(); });
	
	contact_list.mouseleave(function(){ scontacts.fadeOut(); });

	//$("pre").addClass("prettyprint linenums");
    //prettyPrint();
	$("pre").addClass("highlight");
	$.SyntaxHighlighter.init({
//		'prettifyBaseUrl': '{{ site.BASE_PATH }}/assets/resources/jquery-syntaxhighlighter/prettify',
//		'baseUrl': '{{ site.BASE_PATH }}/assets/resources/jquery-syntaxhighlighter',
//		'prettifyBaseUrl': '/assets/resources/jquery-syntaxhighlighter/prettify',
//		'baseUrl': '/assets/resources/jquery-syntaxhighlighter',
		'wrapLines': true,
	});
	
});
