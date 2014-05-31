class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user?, :except => [:index]

  def index
    @user = current_user
    redirect_to user_edit_path(@user) if current_user.new_user?
  end

  def edit
    @user = User.find(params[:id])
    render :setup if @user.new_user?
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

end
