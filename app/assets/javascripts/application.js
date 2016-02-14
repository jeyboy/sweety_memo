//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_directory ./application
//= require_directory ./shared
//= require weather/index
//= require_self

window.update_page = function(url) {
    $content = $('#main_content');
    img_url = $content.attr('data-loading-img');
    $content.html("<img src='" + img_url + "' height='100px' style='display: block; margin: auto;' />");

    if (/\/$/.test(url))
        url += '?format=json';
    else
        url += '.json';

    $.ajax({
        url: url,
        method: $this.attr('data-method') || 'get',
        success: function (response) {
            history.replaceState(null, document.title, url);
            history.pushState(null, document.title, window.last_location);
            window.last_location = url;

            $content.html(response.content);
            async_image_loading();
        },
        error: function(jqXHR, textStatus, errorThrown) {
            $content.html("<h2>Sorry, but some shit happened :(<h2><p>" + errorThrown + "</p>>");
        }
    });
};

window.last_location = location.pathname;

window.onpopstate = function(event) {
    alert("location: " + document.location + ", state: " + JSON.stringify(event.state));
    update_page(document.location, true);
};

$('document').ready(function() {
    $('body').on('click', 'a:not(.direct)', function() {
        $this = $(this);
        url = $this.attr('href');

        if (url != '#' && url != window.last_location) {
            $this.closest('.dropdown.open').removeClass('open');
            if ($(".navbar-toggle:visible").length > 0)
                $(".navbar-collapse.in").collapse('hide');

            update_page(url);

            return false;
        }
    });
});
