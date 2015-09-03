class RefreshDataJob < ActiveJob::Base
  
  queue_as :default

  def perform(current_user)
  	puts "PERFORM"
  	current_user.sync_datas_process
    # Do something later
  end
end
