class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_correct_user!

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
  end

  private

  def secure_params
    params.require(:user).permit(:email)
  end

  def ensure_correct_user!
    unless current_user.id == params[:id].to_i
      redirect_to root_url, :alert => "Access denied"
    end
  end
end
