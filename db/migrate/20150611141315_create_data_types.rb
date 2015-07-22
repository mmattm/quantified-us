class CreateDataTypes < ActiveRecord::Migration
  def change
    create_table :data_types do |t|
      t.string :code, uniqueness: true
      t.string :name
      t.string :description
      t.timestamps null: false
    end
  end
end
