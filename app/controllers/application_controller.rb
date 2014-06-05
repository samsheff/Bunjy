class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :current_user=
  helper_method :user_signed_in?

  private
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_user=(user)
    session[:user_id] = user.id
    @current_user = User.find_by(id: session[:user_id])
  end  

  def signed_in?
    !!current_user
  end

  def user_signed_in?
    signed_in?
  end

  def authenticate_user!
    redirect_to root_url, :alert => 'You need to sign in for access to this page' unless signed_in?
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

end
