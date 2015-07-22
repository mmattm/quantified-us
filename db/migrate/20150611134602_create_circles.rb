class CreateCircles < ActiveRecord::Migration
  def change
    create_table :circles do |t|
      t.string :name
      t.integer :admin_id
      t.timestamps null: false
    end
 
    create_table :circles_users, id: false do |t|
      t.belongs_to :circle, index: true
      t.belongs_to :user, index: true
    end
  end
end