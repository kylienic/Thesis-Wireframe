/**
 * http://www.sitepoint.com/javascript-generate-lighter-darker-color/
 */

function colorLuminance(hex, lum) {
    // Validate hex string
    hex = String(hex).replace(/[^0-9a-f]/gi, "");
    if (hex.length < 6) {
        hex = hex.replace(/(.)/g, '$1$1');
    }
    lum = lum || 0;
    // Convert to decimal and change luminosity
    var rgb = "#",
        c;
    for (var i = 0; i < 3; ++i) {
        c = parseInt(hex.substr(i * 2, 2), 16);
        c = Math.round(Math.min(Math.max(0, c + (c * lum)), 255)).toString(16);
        rgb += ("00" + c).substr(c.length);
    }
    return rgb;
}

/**
 * Custom range slider for demonstration
 */

var slider = document.getElementById('range-slider'),
    color = document.getElementById('hex-color-input'),
    preview = document.getElementById('preview-area');
rangeSlider(slider, {
    drag: function (v) {
        var lighter = colorLuminance(color.value, (v * 0.01)),
            darker = colorLuminance(color.value, -(v * 0.01));
        // Lighter...
        preview.children[0].style.backgroundColor = lighter;
        // Darker...
        preview.children[1].style.backgroundColor = darker;
        // Preview...
        preview.children[0].innerHTML = '<span>&uarr; ' + v + '% = ' + lighter + '</span>';
        preview.children[1].innerHTML = '<span>&darr; ' + v + '% = ' + darker + '<span>';
    }
});