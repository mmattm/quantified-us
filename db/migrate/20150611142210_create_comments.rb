class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :circle, index:true
      t.belongs_to :user

      t.text :message

      t.timestamps null: false
    end
  end
end
