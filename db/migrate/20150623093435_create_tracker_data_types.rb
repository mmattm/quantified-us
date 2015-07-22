class CreateTrackerDataTypes < ActiveRecord::Migration
  def change
    create_table :tracker_data_types do |t|
      t.belongs_to :tracker_model, index: true
      t.belongs_to :data_type, index: true
      t.timestamps null: false
    end
  end
end
