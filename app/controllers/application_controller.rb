class ApplicationController < ActionController::Base
  layout "application.html+phone"
  protect_from_forgery

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :null_session
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :root_path
  helper_method :root_path

  def root_path
    gon.root_path = request.base_url
  end

  def after_sign_in_path_for(user)
    user.updateLocation(request)
  end


  private

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :date_of_birth) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password, :is_female, :date_of_birth, :avatar) }
  end

end
