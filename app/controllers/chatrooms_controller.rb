class ChatroomsController < ApplicationController

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  def new
    @chatroom = Chatroom.new
    @lesson = Lesson.find(params[:lesson_id])
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @chatroom = Chatroom.new(chatroom_params)
    @chatroom.lesson = @lesson

    if @chatroom.save
      redirect_to @chatroom
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:name, :lesson)
  end

end
