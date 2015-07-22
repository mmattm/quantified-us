class AddLocationToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :lat, :decimal, {:precision=>10, :scale=>6}
  	add_column :users, :lng, :decimal, {:precision=>10, :scale=>6}
  	add_column :users, :city, :string
  	add_column :users, :country, :string
  end
end
