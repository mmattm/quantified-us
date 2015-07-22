class TrackerModel < ActiveRecord::Base
  belongs_to :service_model

  has_many :tracker_data_type
  has_many :data_type, :through => :tracker_data_type
end
