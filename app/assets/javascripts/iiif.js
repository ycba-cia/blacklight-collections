function updateImageData( id ) {
    var manifest = "http://manifests.britishart.yale.edu/manifest/" + id;
    $.ajax({
        type: "HEAD",
        async: true,
        crossDomain: false,
        url: manifest
    }).done(function(message,text,jqXHR){
        $("#iiif_logo").html("<a target='_blank' href='http://mirador.britishart.yale.edu/?manifest=" + manifest + "'><img src='http://manifests.britishart.yale.edu/logo-iiif.png' alt='IIIF Manifest'></a>");
    });
}

function cdsData(url) {
    $.ajax({
        type: "GET",
        async: true,
        crossDomain: true,
        url: url
    }).done(function(message,text,jqXHR){

    });
}
