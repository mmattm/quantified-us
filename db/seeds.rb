# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
def rand_in_range(from, to)
  rand * (to - from) + from
end

def generate_datas(dataType, user, valueRange)
	to_date = Date.today
	from_date   = Date.today - 1.month

	(from_date..to_date).each do |d| 
		data = DataObj.new
		data.value = rand(valueRange.first..valueRange.last)
	
		if dataType.code == 'DIST'
			data.value = data.value / 1000 # Convert To KM
		end
		data.date = d
		dataType.data_objs << data
		user.data_objs << data
		data.save!
  	end
end


NBR_OF_CIRCLES = 5;
NBR_OF_MAPS = 5;
NBR_OF_USERS = 10;

random_cities = ["Lausanne", "Yverdon", "Neuchâtel", "Genève", "Fribourg", "Berne", "Zurich"]
random_lat = [46.519962, 46.778217, 46.992979, 46.198392, 46.801666, 46.947922, 47.368650]
random_lng = [6.633597, 6.641490, 6.931933, 6.142296, 7.145568, 7.444608, 8.539183]


# DATA TYPES —————————————————————————————————————————————————————————
data_types = {'STPS' => ['Steps', 'Number of steps'], 
			'DIST' => ['Distance', 'Distance in kilometers'], 
			'CAL'  => ['Calories', 'Number of calories'], 
			'FL'   => ['Floors', 'Number of floors'], 
			'HR'   => ['Heart Rate', 'Average heart rate'], 
			'ACT'  => ['Activity', 'Activity in minutes'], 
			'ST'   => ['Sleep Time', 'Sleep time in minutes'], 
			'WH'   => ['Weight', 'Weight in Kilogrames'], 
			'MOOD' => ['Mood', 'Mood description']
}

data_types.each do |k,v| 
	DataType.create(:code => k, :name => v[0], :description => v[1])
end

puts "Hello Data Types"

# LIST ALL SERVICES + TRACKERS + SUPPORTED DATA METRICS ———————————————————————
services = {
	'fitbit' => {
		'Charge' => ['STPS','DIST','CAL','FL','ACT','ST','WH'],
		'Charge HR' => ['STPS','DIST','CAL','FL','HR','ST','WH']
	},
	'jawbone' => {
	},
	'misfit' => {
	},
	'nike' => {
	}
}

services.each do |serviceName, tracker| 
	serviceModel = ServiceModel.new
	serviceModel.name = serviceName
	serviceModel.save

	tracker.each do |trackerModel, metrics|
	  trackerModel = TrackerModel.create(:service_model => serviceModel, :name => trackerModel)
	  	metrics.each do |metric|
	  		#pp trackerModel
	  		trackerModel.data_type << DataType.where(code: metric).first()
	  	end
	end
end

puts "Hello Services + Trackers"

# ADMIN —————————————————————————————————————————————————————————
admin               = User.new
admin.first_name    = 'Matthieu'
admin.last_name     = 'Minguet'
admin.is_female     = false
admin.email         = 'minguet.mat@gmail.com'
admin.password      = 'admintest'
admin.date_of_birth = Time.at(rand_in_range(25.years.ago.to_f, 25.years.ago.to_f))
admin.avatar        = File.open("#{Rails.root}/vendor/assets/random_profile_imgs/matthieu.jpg")
admin.save!

service               = Service.new
service.uid           = '3DR77X'
service.oauth_token   = '46ef9d772f55b238dbabbe7a1034823c'
service.oauth_secret  = '56b530f2f555771f1eb6a39679aaf836'
service.service_model = ServiceModel.where(name: 'fitbit').first()
admin.service         = service
service.save!

tracker               = Tracker.new
tracker.mac_address   = 'A7E1E819AAC4'
tracker.lastSyncTime  = Date.today
tracker.user          = admin
tracker.service       = service
tracker.tracker_model = TrackerModel.where(name: 'Charge HR').first()
tracker.save!

puts "Hello Admin"

# CIRCLES —————————————————————————————————————————————————————————
NBR_OF_CIRCLES.times do |i|
	circle          = Circle.new
	circle.name     = ['Family', 'Close Friends', 'Girlfriend', 'Soccer Team', 'Coworkers'][i]
	circle.admin_id = admin.id
	admin.circles << circle

	comment = Comment.new 
	comment.message = Faker::Lorem.paragraph
	circle.comments << comment
	admin.comments << comment
	comment.save!

	circle.save!
end

puts "Hello Circles"



# MAPS —————————————————————————————————————————————————————————
NBR_OF_MAPS.times do |i|
	map           = Map.new
	map.name      = random_cities[i]
	map.latitude  = random_lat[i]
	map.longitude = random_lng[i]
	map.distance  = rand(500..10000)
	
	admin.maps << map

	map.save!
end

puts "Hello Maps"

# USERS —————————————————————————————————————————————————————————
NBR_OF_USERS.times do |i|
	user1               = User.new
	user1.first_name    = Faker::Name.first_name
	user1.last_name     = Faker::Name.last_name
	user1.is_female     = [true, false].sample
	gender              = if (user1.is_female) then 'female' else 'male' end
	user1.date_of_birth = Time.at(rand_in_range(40.years.ago.to_f, 10.years.ago.to_f))
	user1.email         = Faker::Internet.email
	user1.password      = 'admintest'
	user1.avatar        = File.open("#{Rails.root}/vendor/assets/random_profile_imgs/"+ gender + "/" + Random.rand(7).to_s + ".jpg")
	
	random_position     = Random.rand(7)
	user1.city          = random_cities[random_position] 
	user1.lat           = random_lat[random_position] + rand_in_range(-0.05,0.05) 
	user1.lng           = random_lng[random_position] + rand_in_range(-0.05,0.05) 
	user1.country       = "Switzerland"
	#Geocoder Methods
	# coordinates = Geocoder.coordinates(user1.city);
	# user1.lat = coordinates[0];
	# user1.lng = coordinates[1];
	user1.last_sync = Time.at(rand_in_range(0.days.ago.to_f, 10.days.ago.to_f))
    user1.save!

    # Add tracker to user1
    tracker               = Tracker.new
    tracker.lastSyncTime  = Date.today
    tracker.user          = user1
    tracker.service       = service
    tracker.tracker_model = TrackerModel.where(name: 'Charge').first()
    tracker.save!

    # RELATIONSHIPS
    # –– Create external circle for admin
    if(i<1)
    	circle          = Circle.new
    	circle.name     = 'shared circle'
    	circle.admin_id = user1.id
    	user1.circles << circle
    	admin.circles << circle
    	circle.save!
    end
    # –– Create relations with first 5 users and add to admin's circles
    if(i<5)
	    relationship = user1.sent_invites.build(invited_id: admin.id)
	    relationship.save!
	    relationship = admin.sent_invites.build(invited_id: user1.id)
	    relationship.save!

	    # Add User1 to 3 random circles Collection
	    random_circles = admin.circles.sample(3)
	    random_circles.each do |p|
	    	user1.circles << p

	    	#COMMENTS —————————————————————————————————————————————————————————
	    	comment = Comment.new 
	    	comment.message = Faker::Lorem.paragraph
	   		p.comments << comment
	   		user1.comments << comment
	   		comment.save!
	    end
	end

	#DATAS —————————————————————————————————————————————————————————

	DataType.find_each do |dataType|
		
		case dataType.code
		when 'STPS'
			generate_datas(dataType, user1, [2000,20000])
		when 'DIST'
			generate_datas(dataType, user1, [3000,12000])
		when 'CAL'
			generate_datas(dataType, user1, [1700,4000])
		when 'FL'
			generate_datas(dataType, user1, [1,30])
		when 'HR'
			generate_datas(dataType, user1, [60,80])
		when 'ACT'
			generate_datas(dataType, user1, [0,250])
		when 'ST'
			generate_datas(dataType, user1, [330,540])
		when 'WH'
			generate_datas(dataType, user1, [50,90])
		when 'MOOD'	
			generate_datas(dataType, user1, [1,8])
		end
		
	end

end
puts "Hello Comments"
puts "Hello Datas"
puts "Hello Users"

puts "——————— Seeds Completed"

