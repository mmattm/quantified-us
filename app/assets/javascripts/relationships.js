(function() {
	var $$ = Dom7;
	$$(document).on('click', 'a.follow-action', function (e) { 
		console.log("FOLLOW");
		$link = $(this);
		$.ajax({
		     type: "POST",// GET in place of POST
		     contentType: "application/json; charset=utf-8",
		     url: "/relationships",
		     data : JSON.stringify({invited_id: $(this).attr('invited-id')}),
		     dataType: "json",
		     success: function (result) {
		        $link.toggleClass('active').removeClass('black');
		     },
		     error: function (){
		     	$link.toggleClass('active').removeClass('follow-action').addClass('unfollow-action').removeClass('black');
		     	$link.html('<i class="fa fa-check"></i> Followed');
		     	$link.removeAttr('invited-id');
		     }
		});
	})
	$$(document).on('click', 'a.unfollow-action', function (e) { 
		console.log("UNFOLLOW");
		$link = $(this);
		$.ajax({
		     type: "POST",// GET in place of POST
		    // contentType: "application/json; charset=utf-8",
		     url: "/relationships/"+$(this).attr('relationship-id'),
		     data: {"_method":"delete"},
		     dataType: "json",
		     success: function (result) {
		        $link.toggleClass('active').addClass('black');
		     },
		     error: function (){
		     	$link.toggleClass('active').removeClass('unfollow-action').addClass('follow-action').addClass('black');
		     	$link.html('<i class="fa fa-plus"></i> Follow');
		     	$link.removeAttr('relationship-id');
		     	//$link.attr('invited-id', );
		     }
		});
	})
	
})()