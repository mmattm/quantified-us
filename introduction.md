
# 
# test 2





```User.find_each() do |user|
  		if user.service
  			User.sync_datas_process(user)
  		end
  	end ```
