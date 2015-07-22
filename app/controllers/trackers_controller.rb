class TrackersController < ApplicationController
  def index
  	@trackers = current_user.trackers
  end

  def show
  	@tracker = Tracker.find(params[:id])
  	@tracker_metrics = @tracker.tracker_model.data_type
  end
end
