class UsersSyncDatas
  @queue = :users_sync_datas

  def self.perform()
  	
  	User.find_each() do |user|
  		if user.service
  			User.sync_datas_process(user)
  		end
  	end
  	puts "Sync"
  end
end