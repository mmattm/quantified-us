class RenameOldTableToNewTable < ActiveRecord::Migration
  def change
  #	rename_table :data_objs, :datas
  	rename_table :service_models, :service_types
  	rename_table :tracker_models, :tracker_types
  end
end
