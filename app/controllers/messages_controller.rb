class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user

    if @message.save
      context = build_context

      # Call the updated OpenAiService with the message and context
      ai_response = OpenAiService.chat(@message.content, context)

      # Check if the response contains the expected data
      if ai_response
        # Create a new message with the AI response, using a system user or bot
        Message.create(chatroom: @chatroom, user: system_user, content: ai_response)
      else
        Rails.logger.error("OpenAI Error: Response was empty or invalid.")
      end

      # Broadcasting the user message
      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "message", locals: { message: @message })
      )
      head :ok
    else
      render "chatrooms/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  # Builds the context for the OpenAI service
  def build_context
    lesson = @chatroom.lesson
    unit = lesson.unit
    course = unit.course

    previous_messages = @chatroom.messages.order(created_at: :asc).map do |msg|
      {
        user: msg.user.username,
        content: msg.content,
        time: msg.created_at
      }
    end

    # Exclude the current message from the context
    previous_messages.pop if previous_messages.last[:content] == @message.content

    {
      system_message: SystemMessage.last.content,
      course_details: course.details,
      unit_details: unit.details,
      lesson_details: lesson.details,
      messages: previous_messages
    }
  end

  # Replace with actual system user fetching logic
  def system_user
    # Assuming you have a system user or bot user for AI responses
    User.find_by(username: "AI Assistant")
  end
end
