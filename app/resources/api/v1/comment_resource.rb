# EXAMPLE API QUERIES
# => http://localhost:3000/api/v1/users/?filter[first_name]=Matthieu
# => http://localhost:3000/api/v1/users/?filter[age]=20,25
# => http://localhost:3000/api/v1/users/?filter[pos]=48.833300,2.250000, 10



module Api
	module V1
		class CommentResource < JSONAPI::Resource
			attributes :circle_id, :user_id, :message, :created_at, :updated_at
			
			filters :circle_id, :user_id, :message
		end
	end
end

