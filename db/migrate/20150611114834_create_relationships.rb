class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :inviting_id
      t.integer :invited_id

      t.timestamps null: false
    end
  end
end
