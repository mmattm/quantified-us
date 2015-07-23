class UserSyncDatas
  extend Resque::Plugins::Heroku
  @queue = :user_sync_datas

  def self.perform(current_user)
    User.sync_datas_process(current_user)
  end
end