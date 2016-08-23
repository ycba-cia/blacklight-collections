


function updateImageData( id ) {
    var manifest = "http://manifests.britishart.yale.edu/manifest/" + id;
    $.ajax({
        type: "HEAD",
        async: true,
        crossDomain: false,
        url: manifest
    }).done(function(message,text,jqXHR){
        $("#ycba-thumbnail-controls").append(
            "<a target='_blank' class='' href='http://mirador.britishart.yale.edu/?manifest=" + manifest + "'><img src='http://manifests.britishart.yale.edu/logo-iiif.png' class='img-responsive' alt='IIIF Manifest'></a>");
    });
}

var objectImages = [];

function cdsData(url) {
    if (objectImages.length == 0) {
        $.ajax({
            type: "GET",
            async: true,
            crossDomain: true,
            url: url
        }).done(function (data, textStatus, jqXHR) {
            $.each(data, function (index, value) {
                var d = value['derivatives'];
                var derivatives = [];
                derivatives['metadata'] = value['metadata'];
                $.each(d, function (index, value) {
                    var image = [];
                    image['format'] = value['format'];
                    image['size'] = value['sizeBytes'];
                    image['id'] = value['contentId'];
                    image['width'] = value['pixelsX'];
                    image['height'] = value['pixelsY'];
                    image['url'] = value['url'];
                    derivatives[index] = image;
                    console.log(image);
                });
                objectImages[index] = derivatives;
            });
            console.log(objectImages);
            renderCdsImages();
        });
    }
}

function renderCdsImages() {
    html = "";

    if (objectImages.length > 0) {
        var data = objectImages[0];
        setMainImage(data);
    }

    if (objectImages.length > 1) {
        var html = "";
        $.each(objectImages, function(index, data){
            console.log(objectImages);
            html += "<div class='col-xs-6 col-sm-3 col-md-6'>"
                + "<a href='#' onclick='setMainImage(objectImages[" + index + "]);'><img class=' img-responsive' src='"
                + data[1]['url'] + "'/></a>"
                + data['metadata']['caption']
                + "</div>";
            if ( (index + 1) % 4 == 0) {
                html += "<div class='clearfix visible-xs-block visible-sm-block'></div>";
            } else if ( (index + 1) % 2 == 0) {
                html += "<div class='clearfix visible-med-block visible-lg-block'></div>";
            }
        });
        html += "";
        $("#ycba-thumbnail-row").append(html);
    }
}

function setMainImage(image) {
    var derivative = image[2] || image[1];
    var metadata = image['metadata'];
    var large_derivative = image[3] || image[2] || image[1];

    if (derivative) {
        var html = "";
        html += "<img class='img-responsive hidden-sm' src='" + derivative['url'] + "' />";
        html += "<img class='img-responsive visible-sm-block lazy' data-original='" + large_derivative['url'] + "' />";
        $("#ycba-main-image").html(html);
    }

    if (metadata) {
        var caption = metadata['caption'];
        if (caption) {
            $("#ycba-main-image-caption").html(caption);
        }
    }
    $("img.lazy").lazyload();
}

function applyLightSlider() {
    $("#thumbnailselector").lightSlider({
        item: 4,
        slideMargin: 10
    });
}