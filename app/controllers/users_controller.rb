class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:locked]
  before_filter :ensure_correct_user!, except: [:locked]
  before_filter :active_account!

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

  def locked
  end

  private
  def secure_params
    params.require(:user).permit(:email)
  end

  def ensure_correct_user!
    unless current_user and current_user.id == params[:id].to_i
      redirect_to root_url, :alert => "Access denied"
    end
  end
end
