class SystemMessagesController < ApplicationController
  before_action :ensure_admin!

  def show
    @system_message = SystemMessage.last
  end

  def edit
    @system_message = SystemMessage.last

  end

  def update
    @system_message = SystemMessage.last
    if @system_message.update(system_message_params)
      redirect_to system_message_path(@system_message)
    else
      render :edit, status: :unprocessable_entity
    end

  end
  private
  def system_message_params
    params.require(:system_message).permit(:content)
  end
end
