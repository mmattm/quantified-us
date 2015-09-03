class SyncDatas
  # Synchronize datas from user
  def self.sync(user)
    puts "Synchronize ————————————————————————————————————————————————"

    user = User.find(user['id'])
    puts user.service.service_type.name
    puts user.service['oauth_token']
    puts user.service['oauth_secret']

    #FITBIT ————————————————————————————————————————————————
    if(user.service.service_type.name == 'fitbit')

      client = Fitgem::Client.new(
        :consumer_key => Devise.omniauth_configs[:fitbit].strategy.consumer_key,
        :consumer_secret => Devise.omniauth_configs[:fitbit].strategy.consumer_secret,
        :token => user.service['oauth_token'],
        :secret => user.service['oauth_secret'],
      :unit_system => Fitgem::ApiUnitSystem.METRIC)

      # UPDATE DEVICES
      client_request = client.devices

      puts client_request

      if client_request.any?
        client_request.each do |k|
          myTracker = Tracker.where(mac_address: k['mac'], user_id: user).first_or_initialize
          # myTracker.device = k['deviceVersion']
          myTracker.tracker_type = TrackerType.where(name: k['deviceVersion']).first()
          myTracker.user = user
          myTracker.service = user.service
          myTracker.lastSyncTime = k['lastSyncTime']
          #pp myTracker
          myTracker.save

          #Get the name of the tracker example
          #pp myTracker.tracker_type.name
        end
      end

      #return
      #UPDATE DATAS
      DataType.find_each do |dataType|
        case dataType.name
        when "Steps"
          request = '/activities/log/steps'
        when "Distance"
          request = '/activities/log/distance'
        when "Calories"
          request = '/activities/log/calories'
        when "Floors"
          request = '/activities/log/floors'
        when "Activity"
          request = '/activities/log/minutesFairlyActive'
        when "Sleep Time"
          request = '/sleep/minutesAsleep'
        when "Weight"
          request = '/body/weight'
        when "Heart Rate"
          request = ''
        when "Mood"
          request = ''
        end

        client_request = client.data_by_time_range(request, {:base_date => Date.today, :period => "3m"})
        # pp dataType.name
        # pp steps

        if(!client_request['errors'].present?)

          values = client_request.values[0]
          values.each do |k|
            val = k['value'].to_f
            date = k['dateTime']
            myData = DataObj.where(date: date, data_type_id: dataType.id, user_id: user).first_or_initialize
            # UPDATE RECORD ONLY IF VALUE CHANGE
            if(myData.value != val)
              myData.value = val
              myData.save
            end
            #end
          end
        end
      end
    end
    # FITBIT END ————————————————————————————————————————————————

    user.last_sync = DateTime.now;
    user.save!
  end
end
