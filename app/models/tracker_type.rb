class TrackerType < ActiveRecord::Base
  belongs_to :service_type

  has_many :tracker_data_type
  has_many :data_type, :through => :tracker_data_type

  has_many :trackers
end
