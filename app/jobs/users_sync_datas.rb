class UsersSyncDatas
  @queue = :users_sync_datas

  def self.perform()
  	puts "hello"
  #  User.sync_datas_process(current_user)
  end
end