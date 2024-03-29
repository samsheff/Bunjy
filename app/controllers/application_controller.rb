class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: "bunjycash", password: "likeaboss" if Rails.env.staging?

  before_filter :valid_api_key?
  
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
  
  def valid_api_key?
    if format_json?
      render json: { error: "Invalid Access Token" } unless lookup_token(params[:token])
    end
  end

  def lookup_token(access_token)
    user = User.find_by_token(access_token)
    if user
      session[:user_id] = user.id
      @current_user = user
      user
    else
      nil
    end
  end

  def format_json?
    request.format.json?
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

  def end_session
    session.destroy
    @current_user = nil
  end

  def active_account!
    if current_user && current_user.locked?
      end_session
      redirect_to '/locked', notice: "This account is currently locked"
    end   
  end

  def is_admin
    redirect_to root_url if !current_user || !current_user.is_any_admin?
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

end
