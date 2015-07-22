class AddColumnsToServices < ActiveRecord::Migration
  def change
    #add_column :services, :provider, :string
    add_column :services, :uid, :string
    add_column :services, :oauth_token, :string
    add_column :services, :oauth_secret, :string
  end
end
