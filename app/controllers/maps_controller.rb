require 'uri'

class MapsController < ApplicationController
  layout :resolve_layout

  def index
  end

  def new
  end

  def new_stp2
    @metrics = User.supported_metrics(current_user)
  end

  def new_stp3
  end

  def show
    @map = Map.find(params[:id])
    gon.model = 'map';

    types = User.supported_metrics(current_user)

    gon.types_svg = []
    types.each do |type|
      gon.types_svg.push(ActionController::Base.helpers.asset_path('svg/metric_'+type.code+'.svg'))
    end

    gon.map_id = @map.id
    gon.current_id = current_user.id
    gon.types = types

    gon.categories = [
      {'code'=> 'OVERALL', 'description'=> 'All participants', 'name'=> 'Overall'},
      {'code'=> 'MALE', 'description'=> 'Male gender participants', 'name'=> 'Male'},
      {'code'=> 'FEMALE', 'description'=> 'Female gender participants', 'name'=> 'Female'},
      {'code'=> 'AGE1', 'description'=> 'From 15 to 19 years old', 'name'=> '15 — 19'},
      {'code'=> 'AGE2', 'description'=> 'From 20 to 24 years old', 'name'=> '20 — 24'},
      {'code'=> 'AGE3', 'description'=> 'From 25 to 29 years old', 'name'=> '25 — 29'},
      {'code'=> 'AGE4', 'description'=> 'From 30 to 34 years old', 'name'=> '30 — 34'},
      {'code'=> 'AGE5', 'description'=> 'From 35 to 39 years old', 'name'=> '35 — 39'},
      {'code'=> 'AGE6', 'description'=> 'From 40 to 44 years old', 'name'=> '40 — 44'},
      {'code'=> 'AGE7', 'description'=> 'From 45 to 49 years old', 'name'=> '45 — 49'},
    {'code'=> 'AGE8', 'description'=> 'From 50 to more years old', 'name'=> '50 — More'}];

    gon.categories_svg = []
    gon.categories.each do |category|
      gon.categories_svg.push(ActionController::Base.helpers.asset_path('svg/category_'+category['code']+'.svg'))
    end

    gon.participants_names = [current_user.first_name + ' .' + current_user.last_name[0], 'Overall Avg.']
    gon.pos = {'latitude' => @map.latitude, 'longitude' => @map.longitude, 'distance' => @map.distance}

    gon.marker = ActionController::Base.helpers.asset_path('svg/marker.svg')
  end

  def create
    map          = Map.new
    map.name     = params[:name]
    map.distance = params[:distance]
    map.latitude = params[:latitude]
    map.longitude = params[:longitude]
    admin = User.find(params[:admin_id])

    admin.maps << map

    map.save!

    respond_to do |format|
      format.json { render json: { } }
    end
  end

  def destroy
    Map.destroy(params[:id])
    respond_to do |format|
      format.js {render :js => "window.location = '/circles'"}
    end
  end

  private

  def resolve_layout
    case action_name
    when "show"
      "application_chart.html+phone"
    end
  end
end
