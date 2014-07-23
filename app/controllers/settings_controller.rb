class SettingsController < ApplicationController
  before_action :find_setting, only: [:edit, :update, :destroy]
  def index
    @settings = Setting.all    
  end

  def new
    @setting = Setting.new
  end

  def create
    @setting = Setting.new(setting_params)
    if @setting.save
      flash[:success] = 'Setting was successfully created.'
      redirect_to settings_path
    else
      render action: 'new'
    end
  end

  def update
    if @setting.update(setting_params)
      flash[:success] = 'Setting was successfully updated.'
      redirect_to settings_path
    else
      render action: 'edit'
    end
  end

  def destroy
    @setting.destroy
    flash[:success] = 'Setting was successfully deleted.'
    redirect_to settings_path
  end

  private
    def setting_params
      params.require(:setting).permit(:name, :value)
    end

    def find_setting
      @setting = Setting.find(params[:id])
    end
end
