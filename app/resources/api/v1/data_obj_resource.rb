# => http://localhost:3000/api/v1/data-objs/?filter[date]=live
# => http://localhost:3000/api/v1/data-objs/?filter[date]=1w
# => http://localhost:3000/api/v1/data-objs/?filter[date]=1m
# => http://localhost:3000/api/v1/data-objs/?filter[date]=live&filter[value]=13595
# => http://localhost:3000/api/v1/data-objs/?filter[date]=live&filter[user]=2,3
# => http://localhost:3000/api/v1/data-objs/?filter[date]=live&filter[age]=24,25
# => http://localhost:3000/api/v1/data-objs/?filter[date]=live&filter[gender]=male&filter[age]=25,26
# => http://localhost:3000/api/v1/data-objs/?filter[date]=live&filter[gender]=male&filter[age]=25,26
# => http://localhost:3000/api/v1/data-objs/?filter[date]=1w&filter[age]=21,21,25,25 // MULTIPLE AGE RANGE
# => http://localhost:3000/api/v1/data-objs/?filter[date]=1w&filter[pos]=46.778217,6.641490,100

module Api
  module V1
    class DataObjResource < JSONAPI::Resource
      attributes :value, :data_type_id, :date
      has_one :user

      filters :value, :data_type_id, :date, :user, :age, :gender, :pos, :user

      def self.apply_filter(records, filter, value, options)
        case filter

        when  :user, :date, :data_type_id, :value, :age, :gender, :pos, :user
          if value.is_a?(Array)

            if filter == :date
              case value[0]
              when "live"
                from = DateTime.now.beginning_of_day
              when "1w"
                from = DateTime.now - 1.week
              when "1m"
                from = DateTime.now - 1.month
              end
              to = DateTime.now.end_of_day
              #pp records
              records = records.where("date > ? AND date < ?", from, to)

            elsif filter == :gender
              if value[0] == 'male' && value[1] == 'female' || value[0] == 'female' && value[1] == 'male'
                users = User.all()
              else
                case value[0]
                when "male"
                  users = User.where("is_female = FALSE")
                when "female"
                  users = User.where("is_female = TRUE")
                end
              end
              records = records.where(user_id: users)

            elsif filter == :age
              users = []
              (0..value.length - 1).step(2) do |index|
                users += User.users_between_age(value[index],value[index+1])
              end

              records = records.where(user_id: users)

            elsif filter == :pos
              if value[0] != 'null'

                distance = value[2].to_f
                distance = distance / 1000 # Convert meters to kilometers
                users_p = User.near([value[0], value[1]], distance)
              else
                users_p = User.all()
              end
              array_users = Array.new
              users_p.each_with_index  do |p, i|
                array_users[i] = p.id

              end
              # pp array_users
              records = records.where(user_id: array_users)

            else
              value.each do |val|
                if filter == :data_type_id
                  records = records.where('data_type_id = ?', val)
                else
                  records = records.where(_model_class.arel_table[filter].matches(val))
                end
              end
            end

            return records

          end
        else
          return super(records, filter, value)
        end
      end
    end
  end
end
