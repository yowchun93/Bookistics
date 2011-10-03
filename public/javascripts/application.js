// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function () {
    $.ajaxSetup({
        'beforeSend' : function (xhr) {
            xhr.setRequestHeader('Accept', 'text/javascript');
        }
    });

    $('a[rel=twipsy]').twipsy({
        live: true,
        placement: 'below'
    });
    $('a[rel=popover]').popover({
        offset: 10,
        placement: 'below'
    });
});