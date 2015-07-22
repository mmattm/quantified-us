class DataType < ActiveRecord::Base
  has_many :data_objs

  has_many :tracker_data_type
  has_many :data_type, :through => :tracker_data_type
end
