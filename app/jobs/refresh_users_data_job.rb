class RefreshUsersDataJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    
    # User.find_each() do |user|
    # 	if user.service
    # 		user.sync_datas_process
    # 	end
    # end
    puts "Sync"
    
  end
end
