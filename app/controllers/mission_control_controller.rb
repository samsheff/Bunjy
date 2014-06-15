class MissionControlController < ApplicationController
  before_filter :is_admin
  layout "admin"

  def index
    redirect_to '/mission-control/users' if current_user.is_any_admin?    
  end

  def users
    @user = current_user
    @app_users = User.includes(:payment_methods, :payments, :withdrawals).all
    render :users
  end

  def payments
    @user = current_user
    @app_payments = Payment.includes(:user).all
    render :payments
  end
  
  def withdrawals
    @user = current_user
    @app_withdrawals = Withdrawal.includes(:user).all
    render :withdrawals
  end

  def settings
    @user = current_user
    @app_settings = Setting.all
    render :settings
  end
end

