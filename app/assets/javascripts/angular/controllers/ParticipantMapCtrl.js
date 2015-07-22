(function() {
	angular.module('datavizualisation').controller('ParticipantMapCtrl', function($scope) {
	    $scope.categories = gon.categories;
	    $scope.categories_svg = gon.categories_svg;
	    $scope.participants = gon.participants_names;
	});
})();