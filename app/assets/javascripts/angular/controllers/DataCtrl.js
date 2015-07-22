(function() {
	angular.module('datavizualisation').controller('DataCtrl', function($scope, $rootScope, $timeout, UserDatas, MapDatas) {
		// Chart.js Data

		var weekdays = [];
		var monthdays = [];
		var hours = [];
		var colours = [	
			['rgba(36,6,134,0.5)', 'rgba(69,14,246,1)'], // BLUE
			['rgba(101,8,173,0.5)', 'rgba(148,8,255,1)'], // PURPLE
			['rgba(10,162,147,0.5)', 'rgba(18,238,216,1)'], // LIGHT BLUE
			['rgba(190,1,23,0.5)', 'rgba(251,7,36,1)'], // RED
			['rgba(201,71,0,0.5)', 'rgba(255,90,0,1)'], // ORANGE
			['rgba(0,165,206,0.5)', 'rgba(0,204,255,1)'],
			['rgba(214,0,71,0.5)', 'rgba(255,0,204,1)'], // PINK
			['rgba(160,184,1,0.5)', 'rgba(217,249,3,1)'], // YELLOW
			['rgba(214,0,71,0.5)', 'rgba(255,0,204,1)'], // PINK
		];
		

		for (var i = 0; i < 7; i++) {
			var day = moment().subtract(i, 'days').format("dddd");
			weekdays.push(day);
		};
		weekdays.reverse();

		for (var i = 0; i < 30; i++) {
			var day = moment().subtract(i, 'days').format("DD/MM");
			if(i%2) day = '';
			monthdays.push(day);
		};
		monthdays.reverse();

		var ctx = document.getElementById('canvas_line').getContext("2d");
			
		// INITIAL PARAMETERS
		$scope.interval = '1w';
		$scope.metric_type = 1;

		$scope.toggleInterval = function(interval) {
			$scope.interval = interval;
			$scope.toggleDatas();
		}

		$scope.toggleTypes = function(type) {
			$scope.metric_type = type+1;
			$scope.toggleDatas();
		}	

		$scope.toggleCategories = function(category) {
		
			//$scope.checkboxCategory[0] = true;
			if(category == 0 && $scope.checkboxCategory[category]){
				for(var index in gon.categories) { 
					if(index != category) $scope.checkboxCategory[index] = true;
				};
			} else if(category == 0 && !$scope.checkboxCategory[category]) {
				for(var index in gon.categories) { 
					if(index != category) $scope.checkboxCategory[index] = false;
				};
			} else {
				$scope.checkboxCategory[0] = false;
			}

			for(var index in gon.categories) { 
			 	if(index > 0 && !$scope.checkboxCategory[index]) {
			 		$scope.checkboxCategory[0] = false;
			 		break;
			 	} 
			 	$scope.checkboxCategory[0] = true;
			}

			$scope.toggleDatas();
		}

		$scope.toggleSwitch = function() {
			console.log($scope.checkboxUser);
		}

		$scope.toggleDatas = function() {
			
				console.log("data");

			switch($scope.interval) {
				case '1w':
				$scope.interval_display = 'Last Week';
				$scope.picto = 'fa fa-clock-o';
				$scope.dateScale = weekdays; 
				break;
				case '1m':
				$scope.interval_display = 'Last Month';
				$scope.picto = 'fa fa-calendar';
				$scope.dateScale = monthdays; 
				break;
				default:
				$scope.interval_display = 'Live';
				$scope.picto = 'fa fa-history';
				$scope.dateScale = weekdays; 
			}
			// var participants = gon.participants.split(",");
			// participants = participants.filter(function(n){ return n != "" }); 

			var datasets = [];
			var charts = [];
			var minParticipants = true;
		
			$scope.participantColor = [];

			$( ".chart canvas" ).each(function() {
				charts.push($(this).attr('chart-type-obj'));
			});
			charts.forEach(function(entry) {
				datasets.push(new Array());
			});

			for (var i in $scope.checkboxUser) {
				if ($scope.checkboxUser[i] === true) {
					minParticipants = false;
					break;
				}
			}
			for (var i in $scope.checkboxType) {
				$scope.checkboxType[i] = (i == $scope.metric_type-1) ? true : false;
			}
		
			
			// CIRCLES
			if(gon.model == 'circle') {
				var radar_data_live = [];
				var user_resources = new Object();

				var datas = UserDatas.query({userId:gon.participantsIds.join(","), dataType:$scope.metric_type, dataInterval: $scope.interval, pos: 'null' }, function() {
					
					// Iterate and create object user resources
					angular.forEach(datas, function(data){
						userId = data.relationships.user.data.id;
						
						if(user_resources[userId] === undefined) user_resources[userId] = [];
						user_resources[userId].push(data.attributes.value);
					});

					// Iterate and create object user resources
					var incr_participant = 0;
					$scope.total = 0;

					// For Each participant, get the resource
					angular.forEach(gon.participantsIds, function(userId){

						var resource = user_resources[userId];

						if(!minParticipants){

						$scope.participantColor[userId] = colours[incr_participant][1];
						
						// If participant selected on switch
						if($scope.checkboxUser[userId]) {

							// Draw Charts
							$scope.drawCharts(charts, incr_participant, resource, datasets, datas, radar_data_live);
						} // END IF IS CHECKED
								
						// Last CALLBACK
						if(incr_participant == gon.participantsIds.length-1) {
							
								$scope.total = commaSeparateNumber(Math.floor($scope.total));
								$scope.data_line = { labels: $scope.dateScale, datasets: datasets[0] };  
								$scope.data_doughnut = datasets[1]; 
								$scope.data_radar = { labels: gon.participants_names, datasets: [datasets[2][0]] }; 
								$scope.data_circle = { labels: $scope.dateScale, datasets: datasets[4] };	
						}	
						
						incr_participant ++;
						
						} else {
							$scope.data_line = { labels: $scope.dateScale, datasets: [0] };  
							$scope.data_doughnut = [0]; 
							//$scope.data_radar = { labels: [], datasets: [] }; 
							$scope.data_circle = { labels: $scope.dateScale, datasets: [0] };
						}
					}); // END FOREACH RESOURCES
					
				}); // END QUERY

			} else if(gon.model == "map") {

				var radar_data_live = [];
				var user_resources = new Object();
				var participant_count = new Object();
				$scope.total = 0;

				// Custom colors for maps
				colours = [	
					['rgba(15,189,200,0.5)', 'rgba(28,232,213,1)'],
					['rgba(255,255,255,0.5)', 'rgba(255,255,255,1)']
				];

				// GENDER
				var genders = [];
				if($scope.checkboxCategory[1]) genders.push('male');
				if($scope.checkboxCategory[2]) genders.push('female');

				// AGE
				var ages = [];
				if($scope.checkboxCategory[3]) ages.push("15","19");
				if($scope.checkboxCategory[4]) ages.push("20","24");
				if($scope.checkboxCategory[5]) ages.push("25","29");
				if($scope.checkboxCategory[6]) ages.push("30","34");
				if($scope.checkboxCategory[7]) ages.push("35","39");
				if($scope.checkboxCategory[8]) ages.push("40","44");
				if($scope.checkboxCategory[9]) ages.push("45","49");
				if($scope.checkboxCategory[10]) ages.push("50","100");

				// query on current user 
				var user_data = UserDatas.query({dataType:$scope.metric_type, dataInterval: $scope.interval, userId: gon.current_id}, function(){
					user_resources['current_user'] = [];
					// Iterate and create object user resources
					angular.forEach(user_data, function(data){
						participant_count[data.relationships.user.data.id] = 1;
						user_resources['current_user'].push(data.attributes.value);
					})
					// Now process to all users
					var overall_datas = MapDatas.query({dataType:$scope.metric_type, dataInterval: $scope.interval, pos: gon.pos.latitude+','+gon.pos.longitude+','+gon.pos.distance, gender: genders.join(","), age: ages.join(',') }, function() {
						
						user_resources['overall'] = [];
					
						// Resample datas by dates
						var resample = new Object();
						var participants_ids = new Object();

						angular.forEach(overall_datas, function(data){
							date = data.attributes.date;
							if(resample[date] === undefined) resample[date] = [];
							resample[date].push(data.attributes.value);

							// Get number of participants
							id = data.relationships.user.data.id;
							if(participants_ids[id] === undefined) participants_ids[id] = 1;
						});


						// Rootscope Participants Ids for MAP
						for (var key in participants_ids) {
						    if (participants_ids.hasOwnProperty(key)) $rootScope.participantsIds.push(parseInt(key));
						};

						$scope.participant_count = countProperties(participants_ids); // add current_user

						// TODO – CASE OF EMPTY DAYS TO CONSIDER
						for(var index in resample) { 
						    var sum = 0;
						    for (var i = 0; i < resample[index].length; i++) {
						    	sum += parseInt( resample[index][i], 10 ); 
						    };
						    // Get average 
						    var avg = sum/resample[index].length;

						    if($scope.metric_type == 2){
						    	avg = parseFloat(avg.toFixed(2));
						    } else {
						    	avg = Math.floor(avg);
						    }
						    user_resources['overall'].push(avg);
						}

						var incr_participant = 0;
						// For Each participant, get the resource
						angular.forEach(user_resources, function(resource, key){

							$scope.participantColor[incr_participant] = colours[incr_participant][1];
							// Draw Charts
							$scope.drawCharts(charts, incr_participant, resource, datasets, overall_datas, radar_data_live);

							// Last CALLBACK
							if(incr_participant) {
								
								$scope.total = commaSeparateNumber(Math.floor($scope.total));
								$scope.data_line = { labels: $scope.dateScale, datasets: datasets[0] };  
								$scope.data_doughnut = datasets[1]; 
								$scope.data_radar = { labels: gon.participants_names, datasets: [datasets[2][0]] }; 
								$scope.data_circle = { labels: $scope.dateScale, datasets: datasets[4] };	
							}	

							incr_participant ++;
						})
					})
				})
			}
					
			// Chart.js Options
			$scope.lineOptions =  {

				segmentShowStroke : false,
				animationEasing : 'easeInOutQuart',
				responsive: true,
				scaleShowGridLines : true,
				scaleGridLineColor : "rgba(255,255,255,.1)",
				scaleGridLineWidth : 1,
				bezierCurve : false,
				bezierCurveTension : 0.1,
				pointDot : false,
				pointDotRadius : 4,
				pointDotStrokeWidth : 1,
				pointHitDetectionRadius : 20,
				datasetStroke : true,
				datasetStrokeWidth : 3,
				datasetFill : false,
				tooltipTitleFontSize: 20,
				tooltipFontFamily: "'LatoLight'",
				tooltipTitleFontFamily: "'Brown'",
				scaleFontFamily: "'LatoLight'",
				onAnimationProgress: function(){},
				onAnimationComplete: function(){},
				//legendTemplate : '<ul class="tc-chart-js-legend"><%  for (var i=0; i< datasets.length; i++){ %><li><span style="color:<%=datasets[i].pointColor%>"><%if(datasets[i].label){%><%=datasets[i].label%><%}%></span></li><%}%></ul>'
			};

			$scope.barOptions =  {
				responsive: true,
				scaleBeginAtZero : true,
				scaleShowGridLines : true,
				scaleGridLineColor : "rgba(255,255,255,0.1)",
				scaleGridLineWidth : 1,
				barShowStroke : false,
				barStrokeWidth : 2,
				barValueSpacing : 0,
				barDatasetSpacing : 0,
				tooltipTitleFontSize: 20,
				tooltipFontFamily: "'LatoLight'",
				tooltipTitleFontFamily: "'Brown'",
				scaleFontFamily: "'LatoLight'",
			};

			// Chart.js Options
			$scope.doughnutOptions =  {	
				segmentShowStroke : false,
				animationEasing : 'easeInOutQuart',
				responsive: true,
				tooltipFontFamily: "'LatoLight'",
				//legendTemplate : '<ul class="tc-chart-js-legend"><% for (var i=0; i<datasets_avg.length; i++){%><li><span style="color:<%=datasets_avg[i].color%>"><%if(datasets_avg[i].label){%><%=datasets_avg[i].label%><%}%></span></li><%}%></ul>'
			}

			$scope.radarOptions =  {
				datasetFill : false,
				animationEasing : 'easeInOutQuart',
				responsive: true,
				scaleShowLine : true,
				angleShowLineOut : true,
				scaleShowLabels : false,
				scaleBeginAtZero : true,
				angleLineColor : 'rgba(255,255,255,0.1)',
				angleLineWidth : 1,
				pointLabelFontSize : 10,
				pointLabelFontColor : '#666',
				pointDot : false,
				pointDotRadius : 3,
				pointDotStrokeWidth : 1,
				pointHitDetectionRadius : 20,
				datasetStroke : false,
				datasetStrokeWidth : 2,
				tooltipFontFamily: "'LatoLight'",
			};

			$scope.circleOptions =  {
				scaleShowGridLines : true,
				scaleGridLineColor : "rgba(255,255,255,.1)",
				scaleGridLineWidth : 1,
				responsive: true,
				datasetFill : false,
				datasetStroke : true,
				pointDot : true,
				datasetStrokeWidth : 0,
				pointDotRadius : 5,
				pointDotStrokeWidth : 2,
				tooltipTitleFontSize: 20,
				tooltipFontFamily: "'LatoLight'",
				tooltipTitleFontFamily: "'Brown'",
				scaleFontFamily: "'LatoLight'",
			};
		};
		
		$scope.drawCharts = function(charts, incr_participant, resource, datasets, datas, radar_data_live){
			angular.forEach(charts, function(chart, key){
			  		var data_obj = new Object();

			  		data_obj.label = gon.participants_names[incr_participant];
			  		// For each charts
			  		switch(chart) {
						// CHART LINE //
						case "line":
						var gradient = ctx.createLinearGradient(0, 100, 0, 240);
						gradient.addColorStop(0, colours[incr_participant][1]);   
						gradient.addColorStop(1, colours[incr_participant][0]);
						data_obj.data = [];
						data_obj.strokeColor = gradient;
						data_obj.fillColor = gradient;
						data_obj.pointHighlightFill = colours[incr_participant][1];
						// data_obj.highlightFill = colours[incr_participant][1];
						// data_obj.highlightStroke = colours[incr_participant][1];
						data_obj.pointColor = colours[incr_participant][1];

						angular.forEach(resource, function(data){
							data_obj.data.push(data);
						});
						break;
						// CHART CIRCLES //
						case "circle":
						data_obj.data = [];
						data_obj.pointColor = 'rgba(0,0,0,1)';
						data_obj.strokeColor = 'rgba(255,255,255,0)';
						data_obj.pointStrokeColor = colours[incr_participant][1];
						data_obj.pointHighlightFill = colours[incr_participant][1];

						angular.forEach(resource, function(data){
							data_obj.data.push(data);
						});
						break;
					    // CHART DOUGHNUT //
					    case "doughnut":
					    	data_obj.color = colours[incr_participant][1];
					    	data_obj.highlight = colours[incr_participant][0];
					    	var avg = 0;
					    	angular.forEach(resource, function(data){
					    		avg += data;
					    	});
					    	$scope.total += avg;
					    	data_obj.value = Math.floor(avg/datas.length);
					    	
					    	break;
					    // CHART RADAR //
					    case "radar":
					   
					    data_obj.data = [];
					    data_obj.strokeColor = 'rgba(255,255,255,1)';
					    data_obj.fillColor = 'rgba(255,255,255,0)';

					    var avg = 0;
					    angular.forEach(resource, function(data){
					    	avg += data;
					    });
					    
					    radar_data_live.push(Math.floor(avg/datas.length));
					    data_obj.data = radar_data_live;
					    break;
					}
					

					datasets[key].push(data_obj);
			}); // END FOREACH CHARTS
		}

		$scope.toggleDatas();
	});
})();


// UTILS 

function commaSeparateNumber(val){
    while (/(\d+)(\d{3})/.test(val.toString())){
      val = val.toString().replace(/(\d+)(\d{3})/, '$1'+'\''+'$2');
    }
    return val;
}

function countProperties(obj) {
    var count = 0;

    for(var prop in obj) {
        if(obj.hasOwnProperty(prop))
            ++count;
    }
    return count;
}

function map_range(value, low1, high1, low2, high2) {
    return low2 + (high2 - low2) * (value - low1) / (high1 - low1);
}
