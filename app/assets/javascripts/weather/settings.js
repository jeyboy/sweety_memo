window.weather_clock = 50;
window.weather_min_objs = 10;
window.weather_def_del = 15000;

function initClientRect() {
    doc = document.documentElement;
    window.uleft = (window.pageXOffset || doc.scrollLeft) - (doc.clientLeft || 0);
    window.utop = (window.pageYOffset || doc.scrollTop)  - (doc.clientTop || 0);
    window.uwidth = window.innerWidth;
    window.uheight = window.innerHeight;
}

function wrapperNode() {
  return document.getElementById('body_wrapper');
}