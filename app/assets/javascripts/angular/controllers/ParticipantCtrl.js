(function() {
	angular.module('datavizualisation').controller('ParticipantCtrl', function($scope, Participant) {
	    $scope.participants = Participant.query();
	});
})();