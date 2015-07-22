class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
   	  t.belongs_to :user, index:true
      t.string :name
      t.float :latitude
      t.float :longitude
      t.float :distance
      
      t.timestamps null: false
    end
  end
end
