class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user
    if @message.save
      # Retrieve the associated lesson, unit, and course
      lesson = @chatroom.lesson
      unit = lesson.unit
      course = unit.course

      # Get the previous messages in the chatroom
      previous_messages = @chatroom.messages.order(created_at: :asc).map do |msg|
        {
          user: msg.user.username,
          content: msg.content,
          time: msg.created_at
        }
      end

      # Exclude the current message from the context
      previous_messages.pop if previous_messages.last[:content] == @message.content

      # Build the context
      context = {
        course_details: course.details,
        unit_details: unit.details,
        lesson_details: lesson.details,
        messages: previous_messages
      }

      response = OpenAiService.chat(@message.content, context)

      if response.key?('choices')
        ai_response = response['choices'].first['text']
      # Save the response as a new message, perhaps as a system user or bot
        Message.create(chatroom: @chatroom, user: current_user, content: response['choices'].first['text'])
      else
        Rails.logger.error("OpenAI Error: #{response['error']['message']}")
      end
      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "message", locals: {message: @message})
      )
      head :ok
      # redirect_to chatroom_path(@chatroom)
    else
      render "chatrooms/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
