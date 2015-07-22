class Service < ActiveRecord::Base
  belongs_to :user
  has_many :trackers

  belongs_to :service_model
end
