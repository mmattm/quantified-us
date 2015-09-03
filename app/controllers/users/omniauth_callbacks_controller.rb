class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def fitbit
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])

      #redirect_to current_user
      if @user.persisted?
        if !@user.nil?
          
          sign_in @user#this will throw if @user is not activated
          #redirect_to @user
          
          @user.updateLocation(request)
          redirect_to dashboard_path
        else 
          redirect_to root_path
        end
        #set_flash_message(:notice, :success, :kind => "Fitbit") if is_navigational_format?
      else
        avatar = request.env["omniauth.auth"]['extra']['raw_info']['user']['avatar150']
        session["devise.fitbit_data"] = request.env["omniauth.auth"].except("extra")
        session["devise.fitbit_data"].avatar = avatar
        redirect_to new_user_registration_url
      end
  end

  def jawbone
      @user = User.from_omniauth(request.env["omniauth.auth"])
      redirect_to root_path
     
  end
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
