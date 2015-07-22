class TrackerDataType < ActiveRecord::Base
  belongs_to :tracker_model
  belongs_to :data_type

  validates :tracker_model_id, uniqueness: { scope: :data_type_id }
end
