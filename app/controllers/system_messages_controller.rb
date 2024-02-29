class SystemMessagesController < ApplicationController

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

end
