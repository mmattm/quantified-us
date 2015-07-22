class RelationshipsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  def index
    @sent_invites = current_user.sent_invites
    @received_invites = current_user.received_invites
    #render :template => "relationships/index.html+phone.erb"
  end

  def followers
    @user = User.find(params[:id])
    @received_invites = @user.received_invites
  end

  def following
    @user = User.find(params[:id])
    @sent_invites = @user.sent_invites
  end

  def create
    @invited_user = User.find(params[:relationship][:invited_id])
    @relationship = current_user.sent_invites.build(invited_id: @invited_user.id)

    if @relationship.save
      flash[:success] = "Successfully invited"

      if request.xhr?  # ajax request
        respond_to do |format|
          format.js {render :nothing => true}
        end
      else
        redirect_to @invited_user
      end
    else
      flash[:danger] = "Unsuccessful"
      redirect_to @invited_user
    end
  end


  def destroy
    @relationship = Relationship.find(params[:id])

    if @relationship.inviting_user == current_user
      @relationship.destroy
      flash[:success] = "Removed relationship"
    end
    redirect_to @relationship.invited_user
  end


end
