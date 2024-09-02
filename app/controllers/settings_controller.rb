class SettingsController < ApplicationController
  before_action :ensure_admin!

  def index
    @openai_model = Setting.find_by(key: 'openai_model')&.value
    @openai_enabled = Setting.find_by(key: 'openai_enabled')&.value == 'true'
  end

  def create
    update_openai_model(params[:openai_model]) if params[:openai_model].present?
    update_openai_enabled(params[:openai_enabled])
    redirect_to settings_path, notice: 'Settings updated successfully.'
  end

  def update
    update_openai_model(params[:openai_model]) if params[:openai_model].present?
    update_openai_enabled(params[:openai_enabled])
    redirect_to settings_path, notice: 'Settings updated successfully.'
  end

  private

  def update_openai_model(model)
    setting = Setting.find_or_initialize_by(key: 'openai_model')
    setting.value = model
    setting.save

  end

  def update_openai_enabled(enabled)
    setting = Setting.find_or_initialize_by(key: 'openai_enabled')
    setting.value = (enabled == 'true').to_s
    setting.save
  end
end
