class Tracker < ActiveRecord::Base
  belongs_to :user
  belongs_to :service

  belongs_to :tracker_model

end
