class AddLastSyncToUsers < ActiveRecord::Migration
	def change
	  add_column :users, :last_sync, :datetime

	end
end
