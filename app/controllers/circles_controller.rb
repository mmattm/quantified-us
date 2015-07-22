class CirclesController < ApplicationController
  layout :resolve_layout
  respond_to :html, :js, :json
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @circles = current_user.circles.order('created_at DESC')
    @maps = current_user.maps.order('created_at DESC')
  end

  def new
  end

  def new_stp2
    @metrics = User.supported_metrics(current_user)
  end

  def new_stp3
    @participants = current_user.received_invites
  end

  def show
    @circle = Circle.find(params[:id])
    @participants = @circle.users
    gon.model = 'circle';

    participants_names = []
    participants_ids = []

    @participants.each do |participant|
      participants_ids.push(participant.id)
      participants_names.push(participant.first_name + ". " + participant.last_name[0])
    end

    gon.participants_names = participants_names
    gon.participantsIds = participants_ids

    types = User.group_supported_metrics(@participants)

    gon.types_svg = []
    types.each do |type|
      gon.types_svg.push(ActionController::Base.helpers.asset_path('svg/metric_'+type.code+'.svg'))
    end
    #@current_id = current_user.id;

    gon.circle_id = @circle.id
    gon.current_id = current_user.id
    gon.types = types
    gon.comments = @circle.comments

    # Remove excess of slashes from url
    url = URI.parse(root_url + comments_path)
    url.path.gsub! %r{/+}, '/'
		gon.comment_path =  url.to_s
		
	end

	def create
		
		circle          = Circle.new
		circle.name     = params[:name]
		circle.admin_id = params[:admin_id]
		admin = User.find(circle.admin_id)
		participants = User.find(params[:participants])

		admin.circles << circle
		participants.each do |participant|
			participant.circles << circle
		end
		
		circle.save!

		respond_to do |format|
		  format.json { render json: { } }
		end
		#redirect_to circles_path
	end

	def destroy
		Circle.destroy(params[:id])
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
