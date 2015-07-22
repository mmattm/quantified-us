(function() {

    window.F7H = {
        app: new Framework7({
            pushState: true,
            pushStateSeparator: '',
            pushStateRoot: gon.root_path,
            pushStateNoAnimation: true
        }),
        dom: Framework7.$
    };

    window.Phone = {
        Views: {}
    };

    Phone.Views.Main = F7H.app.addView('.view-main', {
        dynamicNavbar: true,
        domCache: false,
        swipeBackPage: false,
        // reloadPages: true
    });

    // HACK FOR NAVBAR CENTERING
    window.dispatchEvent(new Event('resize'));

    // Dashboard transparent navbar ## CALLBACK
    window.F7H.app.onPageBeforeInit('*', function(page) {
        $('.navbar').removeClass('dashboard');
    });

    window.F7H.app.onPageBeforeInit('dashboard', function(page) {
        // console.log($(".page[data-page='dashboard']").hasClass('page-on-center'));
        if ($(".page[data-page='dashboard']").hasClass('page-on-center') || $(".page[data-page='dashboard']").length > 1) {
            $('.navbar').addClass('dashboard');
            $(".page[data-page='dashboard']").addClass('dashboard');
        }
    });


    $('form#new_user').submit(function() {
        var valuesToSubmit = $(this).serialize();
        $.ajax({
            type: "POST",
            url: $(this).attr('action'), //sumbits it to the given url of the form
            data: valuesToSubmit,
            dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
        }).success(function(json) {
            console.log("success", json);
            //window.F7H.app.closeModal()
            //window.Phone.Views.Main.router.loadPage('/'); 
            location.reload();
        }).error(function() {
            alert("Wrong Informations");
        });
        return false; // prevents normal behaviour
    });

    $(".ajax-link").click(function() {
        $.ajax({
            type: "GET",
            url: $(this).attr('href'), //sumbits it to the given url of the form
        }).success(function(json) {
            location.reload();
        })
    });


    
})();
