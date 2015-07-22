class CreateTrackerModels < ActiveRecord::Migration
  def change
    create_table :tracker_models do |t|
      t.belongs_to :service_model
      t.string :name
      t.timestamps null: false
    end
  end
end
