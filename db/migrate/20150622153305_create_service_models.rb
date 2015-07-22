class CreateServiceModels < ActiveRecord::Migration
  def change
    create_table :service_models do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
