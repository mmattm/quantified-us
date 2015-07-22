# EXAMPLE API QUERIES
# => http://localhost:3000/api/v1/users/?filter[first_name]=Matthieu
# => http://localhost:3000/api/v1/users/?filter[age]=20,25
# => http://localhost:3000/api/v1/users/?filter[pos]=48.833300,2.250000, 10



module Api
	module V1
		class UserResource < JSONAPI::Resource
			attributes :first_name, :last_name, :date_of_birth, :is_female, :lat, :lng, :last_sign_in_at
			attribute :avatar_url

			has_many :data_objs, acts_as_set: true

			filters :first_name, :last_name, :age, :gender, :pos

			def avatar_url
			    "#{@model.avatar.url(:medium)}"
			end

			def self.apply_filter(records, filter, value, options)
				case filter
			
				when  :last_name, :first_name, :age, :gender, :pos
					
					if value.is_a?(Array)
						if filter == :age
							users = User.users_between_age(value[0],value[1])
     						records = records.where(id: users)	

						elsif filter == :pos
							#pp User.near([value[0], value[1]], 20) 
							#pp User.near("Paris", 100, latitude: 10, longitude: 10)
							distance = value[2].to_f 
							distance = distance / 1000 # Convert meters to kilometers 
							records = records.near([value[0], value[1]], distance) 
						elsif filter == :gender
							case value[0]
							when "male"
								records = records.where("is_female = FALSE")
							when "female"
								records = records.where("is_female = TRUE")
							end

						else
							value.each do |val|
									records = records.where(_model_class.arel_table[filter].matches(val))
							end
						end
						return records

					end
					#from_date = Date.strptime(:date_from, "%m/%d/%Y")
				

				else
					return super(records, filter, value)
				end
			end
		end
	end
end

