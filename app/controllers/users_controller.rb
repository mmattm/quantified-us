class UsersController < ApplicationController
  # before_filter :authenticate_user!
  skip_before_filter :verify_signed_out_user

  def index
    
  end

  def show
    @user = User.find(params[:id])
    @user_followers = Relationship.where(invited_id: @user).count
    @user_following = Relationship.where(inviting_id: @user).count

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def dashboard
    colours_array = ['#2e08a8', '#e71d35', '#1f076c', '#9000ff', '#0fe4c0', '#ee920e']
    @poly = colours_array.shuffle
    @shape = [rand(-15..0), rand(5..40),rand(76..120), rand(0..0),rand(50..120), rand(60..80), rand(-15..0), rand(100..120)]
    @circles_count = current_user.circles.count
    @maps_count = current_user.maps.count

    @random_user1 = User.find(2)
    @random_user2 = User.find(3)
  end

  def settings

  end

  def sync_datas
    # MANUAL
   # User.sync_datas_process(current_user)

    # WITH REDIS
    Resque.enqueue(UserSyncDatas, current_user)
    redirect_to dashboard_path
  end

end
