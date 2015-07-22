(function() {
	angular.module('datavizualisation')
	.controller('CommentCtrl', function($http, $rootScope, $scope, Participant, Comment) {
	    
	    $scope.updateMessages = function(){
	    	//console.log("update_message");
	    	$scope.current_id = gon.current_id;
	    	$scope.circle_id = gon.circle_id;

	    	var comments_list = new Object();
	    	
	    	Comment.query(function(comments) {
	    		angular.forEach(comments, function(comment, key) {
	    			var date = moment(comment.attributes['created-at']).format('YYYY-MM-DD');
	    			if(comments_list[date] == null) comments_list[date] = new Array();
	    			comments_list[date].push(comment.attributes);
	    			
	    		});
	    		$scope.comments = comments_list;
	    		$rootScope.nbr_comments = comments.length;

	    		// Format object participants to have Id as Key and resource as value
	    		var participants = new Object();
	    		Participant.query(function(participant) {
	    			angular.forEach(participant, function(value, key) {
	    			  participants[value.id] = value;
	    			})
	    			$scope.participants = participants;
	    		})	    		
	    	})
	    }

	    $scope.sendMessage = function(){
	    	if($scope.textModel != undefined) {
	    		//console.log($scope.textModel);
	    		$http({
	    		    method: 'POST',
	    		    url: gon.comment_path,
	    		    data: $.param({comment: $scope.textModel, current_user: $scope.current_id, circle_id : $scope.circle_id}),
	    		    headers: {'Content-Type': 'application/x-www-form-urlencoded'}
	    		}).success(function(){ $scope.updateMessages();  $scope.textModel = '';  }).error(function(){});
	    	}
	    }

	    $scope.updateMessages(); 
	});
})();
