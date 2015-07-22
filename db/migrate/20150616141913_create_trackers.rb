class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.belongs_to :user, index: true
      t.belongs_to :service
      t.belongs_to :tracker_model

      t.string :mac_address
      #t.string :device
      t.datetime :lastSyncTime
      t.timestamps null: false
    end
  end
end
