class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.belongs_to :user, index: true
      t.belongs_to :service_model
      
      #t.string :name
      t.timestamps null: false
    end
  end
end
