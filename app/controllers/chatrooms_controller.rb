class ChatroomsController < ApplicationController

  def index
    @user = current_user
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
    @user = current_user
    @lesson = Lesson.find(params[:lesson_id])
    @chatroom = Chatroom.new(name: "Chatroom for #{@lesson.name} #{@lesson.chatrooms.count}", lesson: @lesson, user: @user)
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @user = current_user
    @chatroom = Chatroom.new(name: "Chatroom for #{@lesson.name} #{@lesson.chatrooms.count}", lesson: @lesson, user: @user)

    if @chatroom.save
      redirect_to lesson_chatrooms_path(@lesson)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @chatroom = Chatroom.find(params[:id])
    @lesson = @chatroom.lesson
    @chatroom.destroy
    redirect_to lesson_chatrooms_path(@lesson), status: :see_other
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:name, :lesson)
  end

end
