class ChatroomsController < ApplicationController

  def index
    @lesson = Lesson.find(params[:lesson_id])
    @chatrooms = @lesson.chatrooms
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @lesson = @chatroom.lesson
    @unit = @lesson.unit
    @course = @unit.course
    @messages = @chatroom.messages
    @context = {
      sytem_message: SystemMessage.last.content,
      course_details: @course.details,
      unit_details: @unit.details,
      lesson_details: @lesson.details,
      messages: @messages.map { |m| { user: m.user.username, content: m.content, time: m.created_at } }
    }
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

  def destroy
    @chatroom = Chatroom.find(params[:id])
    @lesson = @chatroom.lesson
    @chatroom.destroy
    redirect_to lesson_path(@lesson), status: :see_other
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:name, :lesson)
  end

end
