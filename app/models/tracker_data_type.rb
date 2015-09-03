class TrackerDataType < ActiveRecord::Base
  belongs_to :tracker_type
  belongs_to :data_type

  validates :tracker_type_id, uniqueness: { scope: :data_type_id }
end
