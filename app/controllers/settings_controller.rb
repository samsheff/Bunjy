class SettingsController < ApplicationController
  before_filter :is_admin
  layout "admin"

  def edit
    @user = current_user
    @setting = Setting.find(params[:id])
  end

  def new
    @user = current_user
  end

  def create
    Setting.create_setting(secure_params)
    redirect_to "/mission-control/settings"
  end

  def update
    Setting.find(params[:id]).update(setting_value: secure_params[:value])
    redirect_to "/mission-control/settings"
  end

  def delete
    Setting.find(params[:id]).destroy
    redirect_to "/mission-control/settings"
  end

  private

  def secure_params
    params.require(:setting).permit(:name, :value, :data_type)
  end

end


