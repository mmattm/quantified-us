(function() {
    var $$ = Dom7;
    var pos = {};
    // Page Init
    window.F7H.app.onPageBeforeInit('circles', function(page) {

        //- Two groups
        $$('.circle-new-options').on('click', function() {
            var buttons1 = [{
                text: 'Choose a type of view',
                label: true

            }, {
                text: 'Circle',
                onClick: function() {
                    window.Phone.Views.Main.loadPage('/circles/new/');
                }
            }, {
                text: 'Map',
                onClick: function() {
                    window.Phone.Views.Main.loadPage('/maps/new/');
                }
            }];
            var buttons2 = [{
                text: 'Cancel',
                color: 'red'
            }];
            var groups = [buttons1, buttons2];
            window.F7H.app.actions(groups);
        });
        rollBg();
    });


    // CREATION STEPPER CIRCLES

    window.F7H.app.onPageBeforeInit('new-circle', function(page) {
        $$(document).on('click', '.button-next-name-circle', function(e) {
            e.preventDefault();
            if ($("input[name='circle-name']").val().length == 0) {
                window.F7H.app.alert("You must enter a name", 'Error');
                //window.Phone.Views.Main.loadPage('/circles/new/metrics');
            } else {
                window.Phone.Views.Main.loadPage('/circles/new/metrics');
            }
        })

    });

    window.F7H.app.onPageInit('new-circle-2', function(page) {
        $("input[name='circle-name-hidden']").val($("input[name='circle-name']").val())
    });

    window.F7H.app.onPageInit('new-circle-3', function(page) {

        var metrics = [];

        $(':checkbox:checked[name=metric]').each(function(i) {
            metrics[i] = $(this).attr('metric');
        });

        // SEND AJAX CIRCLE
        $$(document).on('click', '.complete', function(e) {
            e.preventDefault();

            var name = $("input[name='circle-name-hidden']").val();
            var id = $("input[name='id-hidden']").val();
            var participants = [];

            $(':checkbox:checked[name=participants]').each(function(i) {
                participants[i] = $(this).attr('participant');
            });

            if (participants.length == 0) {
                window.F7H.app.alert("You must choose a least one participant", 'Error');
            } else {
                $.ajax({
                    type: "POST", // GET in place of POST
                    contentType: "application/json; charset=utf-8",
                    url: "/circles",
                    data: JSON.stringify({
                        name: name,
                        admin_id: id,
                        participants: participants,
                        metrics: metrics
                    }),
                    dataType: "json",
                    success: function(result) {
                        console.log("success");
                        window.location = '/circles'
                    },
                    error: function() {
                        window.F7H.app.alert("error, 'Error!'");
                    }
                });
            }

        })
    });

    // ———————————————————————————————————————————————————————

    // CREATION STEPPER MAPS
    window.F7H.app.onPageBeforeInit('new-map', function(page) {
        $$(document).on('click', '.button-next-name-map', function(e) {
            e.preventDefault();
            if ($("input[name='map-name']").val().length == 0) {
                window.F7H.app.alert("You must enter a name", 'Error');
                //window.Phone.Views.Main.loadPage('/circles/new/metrics');
            } else {
                window.Phone.Views.Main.loadPage('/maps/new/metrics');
            }
        })
    });

    window.F7H.app.onPageInit('new-map-2', function(page) {
        $("input[name='map-name-hidden']").val($("input[name='map-name']").val())
    });

    window.F7H.app.onPageInit('new-map-3', function(page) {
        initialize();
        $('.complete-map').hide();
    });


    $$(document).on('click', 'a.circles-link', function(e) {
        $('h2').removeClass('active');
        $('h2', this).toggleClass('active');
        $('.maps-elements').stop().fadeOut(500, function() {
            $('.circles-elements').stop().fadeIn(500);
        });
    });
    $$(document).on('click', 'a.maps-link', function(e) {
        $('h2').removeClass('active');
        $('h2', this).toggleClass('active');
        $('.circles-elements').stop().fadeOut(500, function() {
            $('.maps-elements').stop().fadeIn(500);
        });
    });

    function newGradient() {
        var c1 = {
            r: Math.floor(Math.random() * 255),
            g: Math.floor(Math.random() * 255),
            b: Math.floor(Math.random() * 255)
        };
        var c2 = {
            r: Math.floor(Math.random() * 255),
            g: Math.floor(Math.random() * 255),
            b: Math.floor(Math.random() * 255)
        };
        c1.rgb = 'rgb(' + c1.r + ',' + c1.g + ',' + c1.b + ')';
        c2.rgb = 'rgb(' + c2.r + ',' + c2.g + ',' + c2.b + ')';
        return 'radial-gradient(at top left, ' + c1.rgb + ', ' + c2.rgb + ')';
    }

    function rollBg() {
        $('.circle .round-image-35').each(function() {
            $(this).css('background', newGradient())
        })
    }

    // MAP LOCATION
    function showDistanceSelector() {

        $(".button-map-container").show();

        var size = 100;

        $$('.button-next-position.button-map').on('click', function() {
            $('.distance-number-calcul').text(size * 10);

            $(this).hide();
            $("#distance-selector").fadeIn(500);

            var circle = document.querySelector("#circle");
            $("#circle").center().stop().fadeTo('fast', 0.3);
            var pad = document.querySelector("#distance-selector");
            var hammerPad = new Hammer(pad);

            hammerPad.on("tap press panstart panmove panend panleft panright pantop pandown panup swipeup swipedown swiperight swipeleft", function(event) {

                var pointer0 = event.pointers[0];

                // circle.style.left = pointer0.clientX+"px";
                // circle.style.top = pointer0.clientY+"px";

                if (event.type.match(/start|tap|press/g)) {
                    //  $("#circle").fadeTo('fast', 1);
                    $("#circle").stop().fadeTo('fast', 0.6);
                    $('.complete-map').hide();
                }

                if (!event.type.match(/move/g)) {

                    if (event.type == 'panright') {
                        if (size >= 400) size = 400;
                        size += 5;

                    } else if (event.type == 'panleft') {
                        if (size <= 100) size = 100;
                        size -= 5;
                    }

                    $('.distance-number-calcul').text(size * 10);
                }


                if (event.type.match(/end/g)) {
                    $("#circle").stop().fadeTo('fast', 0.3);
                    $('.complete-map').fadeIn(300);
                }

                circle.style.width = size + "px";
                circle.style.height = size + "px";
                $("#circle").center();

            })
        })

        $$(document).on('click', '.complete-map', function(e) {
            e.preventDefault();
            console.log("complete map");
            var name = $("input[name='map-name-hidden']").val();
            var id = $("input[name='id-hidden']").val();

            // console.log(name);
            // console.log(id);
            // console.log(size*10);

            var metrics = [];

            $(':checkbox:checked[name=metric]').each(function(i) {
                metrics[i] = $(this).attr('metric');
            });

            $.ajax({
                type: "POST", // GET in place of POST
                contentType: "application/json; charset=utf-8",
                url: "/maps",
                data: JSON.stringify({
                    name: name,
                    admin_id: id,
                    distance: size * 10,
                    latitude: pos.latitude,
                    longitude: pos.longitude,
                    metrics: metrics
                }),
                dataType: "json",
                success: function(result) {
                    console.log("success");
                    window.location = '/circles'
                },
                error: function() {
                    window.F7H.app.alert("error, 'Error!'");
                }
            });
        })
    }

    function initialize() {

        var markers = [];
        var map = new google.maps.Map(document.getElementById('map-canvas'), {
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            disableDefaultUI: true,
            center: {
                lat: 46.519962,
                lng: 6.633597
            },
            zoom: 8
        });
        // var defaultBounds = new google.maps.LatLngBounds(
        //     new google.maps.LatLng(-33.8902, 151.1759),
        //     new google.maps.LatLng(-33.8474, 151.2631));
        // map.fitBounds(defaultBounds);

        // Create the search box and link it to the UI element.
        var input = /** @type {HTMLInputElement} */ (
            document.getElementById('pac-input'));
        map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

        var searchBox = new google.maps.places.SearchBox(
            /** @type {HTMLInputElement} */
            (input));

        // [START region_getplaces]
        // Listen for the event fired when the user selects an item from the
        // pick list. Retrieve the matching places for that item.
        google.maps.event.addListener(searchBox, 'places_changed', function() {
            var places = searchBox.getPlaces();

            if (places.length == 0) {
                return;
            }
            for (var i = 0, marker; marker = markers[i]; i++) {
                marker.setMap(null);
            }

            // For each place, get the icon, place name, and location.
            markers = [];
            var bounds = new google.maps.LatLngBounds();
            for (var i = 0, place; place = places[i]; i++) {

                // only first one 
                if (i == 0) {
                    var image = {
                        url: place.icon,
                        size: new google.maps.Size(71, 71),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(17, 34),
                        scaledSize: new google.maps.Size(25, 25)
                    };

                    // Create a marker for each place.
                    var marker = new google.maps.Marker({
                        map: map,
                        icon: image,
                        title: place.name,
                        position: place.geometry.location
                    });

                    markers.push(marker);

                    //bounds.extend(place.geometry.location);
                    var pt = new google.maps.LatLng(marker.position.A, marker.position.F);
                    pos = {
                        'latitude': marker.position.A,
                        'longitude': marker.position.F
                    };
                    map.setCenter(pt);
                    map.setZoom(13);
                    showDistanceSelector();
                }
            }

            //  map.fitBounds(bounds);
        });
        // [END region_getplaces]

        // Bias the SearchBox results towards places that are within the bounds of the
        // current map's viewport.
        google.maps.event.addListener(map, 'bounds_changed', function() {
            var bounds = map.getBounds();
            searchBox.setBounds(bounds);
        });
    }


    // JQUERY UTIL
    jQuery.fn.center = function() {
        this.css("position", "absolute");
        this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
            $(window).scrollTop()) + "px");
        this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
            $(window).scrollLeft()) + "px");
        return this;
    }

})()
