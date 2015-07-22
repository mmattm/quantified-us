(function() {
	angular.module('datavizualisation').controller('MapCtrl', function($scope, Participant) {

		$scope.position = gon.pos;
		
		$scope.zoom = Math.round(map_range($scope.position.distance, 1, 10000, 13,10));

	    $scope.cities = {
	          city: {radius:$scope.position.distance, position: [$scope.position.latitude, $scope.position.longitude]},
	        }
	    $scope.getRadius = function(num) {
	      return num * 2;
	    }

	    $scope.image = {
	        url: gon.marker,        
	        size: [20, 32], 
	        origin: [0,0],
	        anchor: [0, 32]
	      };

	    $scope.users = [];

	    Participant.query(function(participants) {
	    	angular.forEach(participants, function(participant) {
	    		$scope.users.push([participant.attributes['first-name'] + " " + participant.attributes['last-name'], participant.attributes.lat, participant.attributes.lng])
	    	})
	    })
	})
})();