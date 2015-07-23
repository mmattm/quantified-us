(function() {

	var swiper = new Swiper('.swiper-container', {
	    // Disable preloading of all images
	    parallax: true,
	    pagination:'.swiper-pagination'
	});     


	var app = angular.module('datavizualisation', ['ngRoute', 'ngResource', "tc.chartjs", "luegg.directives", 'ngMap']);

	app.run(function($rootScope, $location) {
	    $rootScope.location = $location;
	    $rootScope.participantsIds = [];

	    if(gon.model == 'circle') {
		    $location.path('/participants');

		    $rootScope.nbr_participants = gon.participants_names.length;
		    $rootScope.nbr_comments = gon.comments.length;

		    // Switches States
		 	$rootScope.checkboxUser = { };
		    angular.forEach(gon.participantsIds, function(item){
		      $rootScope.checkboxUser[item] = true;
		    });

		    $rootScope.participantsIds = gon.participantsIds;
		} else {
			$location.path('/map_participants');
		}

		$rootScope.nbr_types = gon.types.length;

		$rootScope.checkboxType = {};
	    angular.forEach(gon.types, function(item, key){
	      $rootScope.checkboxType[key] = false;
	    });

	    $rootScope.checkboxCategory = {};
	    angular.forEach(gon.categories, function(item, key){
	      $rootScope.checkboxCategory[key] = true;
	    });
	  
	});

	angular.module('datavizualisation')
	.directive('banner', function() {
	    return function (scope, element, attrs) {
	        element.height($(window).height() - ($(".navbar").height() + $("#canvas-charts").outerHeight() + $("#chart-nav").height()));
	    }
	})
	.directive('centerchart', function() {
	    return function (scope, element, attrs) {
	        element.css({'margin-top': $('#canvas-charts').height()/2 - element.height()/2  });
	    }
	})


	// Sets up routing
	app.config(function($routeProvider) {
	       $routeProvider
	         
	           .when('/participants', {
	               templateUrl : '../templates/participants.html',
	               controller  : 'ParticipantCtrl'
	           })
	           .when('/metrics', {
	               templateUrl : '../templates/types.html',
	               controller  : 'TypeCtrl'
	           })
	           .when('/comments', {
	               templateUrl : '../templates/comments.html',
	               controller  : 'CommentCtrl'
	           })
	           .when('/map_participants', {
	               templateUrl : '../templates/map_participants.html',
	               controller  : 'ParticipantMapCtrl'
	           })
	           .when('/map', {
	               templateUrl : '../templates/map.html',
	               controller  : 'MapCtrl'
	           });
	   });	

	app.factory('Participant', ['$resource', '$rootScope', function($resource, $rootScope) {
	
	  return $resource(
	  	'/api/v1/users?filter[id]='+ $rootScope.participantsIds.join(", ") +'.json', 
	  	{ }, // Query parameters
        {'query': { 
        	method: 'GET',
        	    params: {},
        	    isArray: true,
        	    transformResponse: function(data, header){
        	      //Getting string data in response
        	      var jsonData = JSON.parse(data); //or angular.fromJson(data)
        	      var datas = [];
        	      angular.forEach(jsonData.data, function(item){
        	        datas.push(item);
        	      });
        	      return datas;
        	    } 
    	}
	  });
	}]);

	app.factory('Comment', ['$resource', function($resource) {

	 // participants = gon.participants
	  return $resource(
	  	'/api/v1/comments?filter[circle_id]='+gon.circle_id+'.json', 
	  	{ }, // Query parameters
	    {'query': { 
	    	method: 'GET',
	    	    params: {},
	    	    isArray: true,
	    	    transformResponse: function(data, header){
	    	      //Getting string data in response
	    	      var jsonData = JSON.parse(data); //or angular.fromJson(data)
	    	      var datas = [];
	    	      angular.forEach(jsonData.data, function(item){
	    	        datas.push(item);
	    	      });
	    	      return datas;
	    	    } 
		}
	  });
	}]);

	app.factory('UserDatas', ['$resource', function($resource) {
	  return $resource(
	  	'/api/v1/data-objs?filter[date]=1m&filter[user]=:userId&filter[data_type_id]=:dataType&filter[date]=:dataInterval', 
	  	{ userId:'@id', dataType:'@id', dataInterval:'@id' }, // Query parameters
	    {'query': { 
	    	method: 'GET',
	    	    params: {},
	    	    isArray: true,
	    	    transformResponse: function(data, header){
	    	      //Getting string data in response
	    	      var jsonData = JSON.parse(data); //or angular.fromJson(data)
	    	      var datas = [];
	    	      angular.forEach(jsonData.data, function(item){
	    	        datas.push(item);
	    	      });
	    	      return datas;
	    	    } 
		}
	  });
	}]);

	
	app.factory('MapDatas', ['$resource', function($resource) {
	  return $resource(
	  	'/api/v1/data-objs?filter[date]=:dataInterval&filter[data_type_id]=:dataType&filter[pos]=:dataInterval&filter[pos]=:pos&filter[gender]=:gender&filter[age]=:age', 
	  	{ userId:'@id', dataType:'@id', dataInterval:'@id', pos:'@id', gender:'@id', age: '@id' }, // Query parameters
	    {'query': { 
	    	method: 'GET',
	    	    params: {},
	    	    isArray: true,
	    	    transformResponse: function(data, header){
	    	      //Getting string data in response
	    	      var jsonData = JSON.parse(data); //or angular.fromJson(data)
	    	      var datas = [];

	    	      angular.forEach(jsonData.data, function(item){
	    	        datas.push(item);
	    	      });
	    	      return datas;
	    	    } 
		}
	  });
	}]);

	$('.ac').on('click', function () {
		var url = '';
		if(gon.model == 'circle') {
			url = "/circles/"+gon.circle_id;
		} else {
			url = "/maps/"+gon.map_id;
		}
	    var buttons = [
	        {
	            text: 'Delete',
	            color: 'red',
	            onClick: function () {
	            	$.ajax({
	            	     type: "POST",// GET in place of POST
	            	     url: url,
	            	     data: {"_method":"delete"},
	            	     success: function (result) {
	            	     },
	            	     error: function (){
	            	     }
	            	});
	            }
	        },
	        {
	            text: 'Cancel',

	        },
	    ];
	    window.F7H.app.actions(buttons);
	});   

	// Dynamically resize charts until everything else has loaded
	$(window).load(function(){
		$(this).on("resize", function () {
		   // positionObject($('#chart-doughnut, #chart-radar'), $('.swiper-container'));
		   //	positionObject($('#doughnut-total'), $('#chart-doughnut .inner-canvas-charts'));
		}).resize();
	});


	function positionObject($obj, $container){
		$obj.css({"margin-top": ( $container.height() - $obj.height() ) /2 +"px"})
		//$obj.css({"margin-left": ( $container.width() - $obj.width() ) /2 +"px"})
	}
	
})();