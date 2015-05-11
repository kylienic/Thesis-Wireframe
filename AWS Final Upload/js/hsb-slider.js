            YUI().use('slider', 'color', function(Y){
                // sliders
    var rSlider = new Y.Slider({ min: 0, max: 255, value: 50 }),
        gSlider = new Y.Slider({ min: 0, max: 255, value: 50 }),
        bSlider = new Y.Slider({ min: 0, max: 255, value: 50 }),

        // slider values
        rVal = Y.one('#r-val'),
        gVal = Y.one('#g-val'),
        bVal = Y.one('#b-val'),

        // color strings
        hex = Y.one('#hex'),
        rgb = Y.one('#rgb'),
        hsl = Y.one('#hsl'),

        // color chip
        color = Y.one('.color');

    // render sliders
    rSlider.render('#r-slider');
    gSlider.render('#g-slider');
    bSlider.render('#b-slider');


                // register update events
    rSlider.after('thumbMove', function(e) {
        rVal.set('text', rSlider.get('value'));
        gVal.set('text', rSlider.get('value'));
        gSlider.set('value', rSlider.get('value'));
        bVal.set('text', rSlider.get('value'));
        bSlider.set('value', rSlider.get('value'));
        updateColors();
    });
    gSlider.after('thumbMove', function(e) {
        gVal.set('text', gSlider.get('value'));
        rVal.set('text', gSlider.get('value'));
        rSlider.set('value', gSlider.get('value'));
        bVal.set('text', gSlider.get('value'));
        bSlider.set('value', gSlider.get('value'));
        updateColors();
    });
    bSlider.after('thumbMove', function(e) {
        bVal.set('text', bSlider.get('value'));
        rVal.set('text', bSlider.get('value'));
        rSlider.set('value', bSlider.get('value'));
        gVal.set('text', bSlider.get('value'));
        gSlider.set('value', bSlider.get('value'));
        updateColors();
    });

    // update the colors strings
    function updateColors() {
        var r = rSlider.get('value'),
            g = gSlider.get('value'),
            b = bSlider.get('value'),
            rgbStr = Y.Color.fromArray([r,g,b], Y.Color.TYPES.RGB);

        color.setStyle('backgroundColor', rgbStr);
    }


            
    rVal.set('text', rSlider.get('value'));
    gVal.set('text', rSlider.get('value'));
    bVal.set('text', rSlider.get('value'));
    updateColors();

            });
