class UserSyncDatas
  @queue = :user_sync_datas

  def self.perform(current_user)
  	puts "hello"
  #  User.sync_datas_process(current_user)
  end
end