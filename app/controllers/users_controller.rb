class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
    ensure_correct_user?
  end

  private

  def secure_params
    params.require(:user).permit(:email)
  end

  def ensure_correct_user?
    unless current_user.id == @user.id
      redirect_to root_url, :alert => "Access denied."
    end
  end
end
