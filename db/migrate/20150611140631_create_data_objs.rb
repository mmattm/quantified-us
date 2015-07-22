class CreateDataObjs < ActiveRecord::Migration
  def change
    create_table :data_objs do |t|
      t.belongs_to :user, index: true
      t.belongs_to :data_type

      t.float :value
      t.datetime :date
      t.timestamps null: false
    end
  end
end
