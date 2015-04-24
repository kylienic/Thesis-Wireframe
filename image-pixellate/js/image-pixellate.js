$(document).ready(function() {

    /// (C) Ken Fyrstenberg Nilsen, Abdias Software, CC3.0-attribute.
    var ctx = canvas.getContext('2d');
    var img = new Image();
    var play = false;

    /// turn off image smoothing - this will give the pixelated effect
    ctx.mozImageSmoothingEnabled = false;
    ctx.imageSmoothingEnabled = false;

    var zoomFactor = 50;
    console.log(zoomFactor);

    /// wait until image is actually available
    img.onload = pixelate;

    /// some image, we are not struck with CORS restrictions as we
    /// do not use pixel buffer to pixelate, so any image will do
    img.src = 'img/butterflies.jpg';
                
    /// MAIN function
    function pixelate(v) {
        /// if in play mode use that value, else use slider value
        //var size = (play ? v : blocks.value) * 0.01,
        var size = zoomFactor * 0.01,

        /// cache scaled width and height
        w = canvas.width * size ,
        h = canvas.height * size;

        /// draw original image to the scaled size
        ctx.drawImage(img, 0, 0, w, h);

        /// then draw that scaled image thumb back to fill canvas
        /// As smoothing is off the result will be pixelated
        ctx.drawImage(canvas, 0, 0, w, h, 0, 0, canvas.width, canvas.height);
    }

    window.requestAnimationFrame = (function () {
        return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || function (callback) {
            window.setTimeout(callback, 1000 / 60);
        };
    })();

    // using the event helper
    var popupyet = false;
    $('#canvas').mousewheel(function(event) {
        event.preventDefault(); // Stop window scroll when mouse is inside canvas
        
        if(zoomFactor == 7 && popupyet== false){
            //pop up that says to click on pixels
            $('#popup').css({
                display: "block",
            });
            popupyet=true;
        } 
        if(event.deltaY > 0 && zoomFactor<50){
            zoomFactor++;
            deltaY=0;
            console.log(zoomFactor);
            pixelate();
        }
        if(event.deltaY < 0 && zoomFactor > 1){
            zoomFactor--;
            deltaY=0;
            console.log(zoomFactor);
            pixelate();
        }
        if (zoomFactor <=0){
            zoomFactor=0;
        }
        if (zoomFactor >=50){
            zoomFactor=50;
        }
        // pixelate();
    });

    function findPos(obj) {
        var curleft = 0, curtop = 0;
        if (obj.offsetParent) {
            do {
                curleft += obj.offsetLeft;
                curtop += obj.offsetTop;
            } while (obj = obj.offsetParent);
            return { x: curleft, y: curtop };
        }
    }

    function rgbToHex(r, g, b) {
        if (r > 255 || g > 255 || b > 255)
            throw "Invalid color component";
        return ((r << 16) | (g << 8) | b).toString(16);
    }

    $('#canvas').mousemove(function(e) {
        var pos = findPos(this);
        var x = e.pageX - pos.x;
        var y = e.pageY - pos.y;
        var coord = "x=" + x + ", y=" + y;
        var c = this.getContext('2d');
        var p = c.getImageData(x, y, 1, 1).data; 
        var hex = "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6);
        var r = p[0];
        var g = p[1];
        var b = p[2];
        var bright = parseInt((r+g+b)/3);
        var brightPercent = parseInt((bright/255)*100);

        $('#status').html("<span class='status-label' id='red'>" + r + "</span> "+" <span class='status-label'> - </span>"+ "<span class='status-label' id='green'>"+ g + "</span><span class='status-label'> - </span>" + "<span class='status-label' id='blue'>"+ b +"</span>");
        document.getElementById("color-box").style.backgroundColor = hex;
        $('.computed#r').html(r);
        $('.computed#g').html(g);
        $('.computed#b').html(b);
        $('.computed#x').html(x);
        $('.computed#y').html(y);
        $('.computed#bright').html(bright + ' / ' + brightPercent + '%');
    });

    $('#canvas').click(function(){
        var yOffset = 200;
        var xOffset = -260;

        $(document).on('mousemove', function(e){
            $('#color-box-wrapper').css("top", (e.pageY - yOffset) + "px").css("left", (e.pageX + xOffset) + "px");
            $('#color-box-background').css("top", (e.pageY - yOffset) + "px").css("left", (e.pageX + xOffset) + "px");
        });
        $('#color-box-wrapper').toggle();
        $('#color-box-background').toggle();
        $('#computed').toggle();
    });

    $('#color-box-wrapper').hide();
    $('#color-box-background').hide();
    $('#computed').hide();

    $('#popup').click(function(){
        $('#popup').css({
           display: "none"
        });
    });

});
