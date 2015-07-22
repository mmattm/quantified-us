(function() {
	angular.module('datavizualisation').controller('TypeCtrl', function($scope, $timeout) {

	    $scope.types = gon.types;
	    $scope.types_svg = gon.types_svg;
      
	});
})();
