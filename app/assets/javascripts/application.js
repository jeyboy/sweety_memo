//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_directory ./application
//= require_directory ./shared
//= require masonry.pkgd.min.js
//= require_self

$('document').ready(function() {
    $('.body').masonry({
        percentPosition: true,
        itemSelector: '.masonry-item'
    });
});
