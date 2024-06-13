class SettingsController < ApplicationController
  def index
    @setting = Setting.find_by(key: 'openai_model')
  end

  def create
    setting = Setting.find_or_initialize_by(key: 'openai_model')
    setting.value = params[:openai_model]
    if OpenAiService::VALID_MODELS.include?(setting.value)
      if setting.save
        redirect_to settings_path, notice: 'Model updated successfully.'
      else
        redirect_to settings_path, alert: 'Failed to update model.'
      end
    else
      redirect_to settings_path, alert: 'Invalid model selected.'
    end
  end

  def update
    setting = Setting.find_by(key: 'openai_model')
    if setting
      setting.value = params[:openai_model]
      if OpenAiService::VALID_MODELS.include?(setting.value)
        if setting.save
          redirect_to settings_path, notice: 'Model updated successfully.'
        else
          redirect_to settings_path, alert: 'Failed to update model.'
        end
      else
        redirect_to settings_path, alert: 'Invalid model selected.'
      end
    else
      create
    end
  end
end
