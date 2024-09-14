class MessagesController < AuthenticationsController
  skip_before_action :ensure_instructor_or_admin!, only: [:create]

  def index
    @messages = Message.order(created_at: :desc).page(params[:page]).per(100)
  end

  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user

    if @message.save
      broadcast_message(@message)
      ai_response = handle_ai_response

      # Broadcast AI response if present
      broadcast_message(ai_response) if ai_response
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
    User.find_by(username: "assistant")
  end

  def handle_ai_response
    context = build_context
    ai_content = OpenAiService.chat(@message.content, context)

    if ai_content
      #ai_message =
      Message.create(chatroom: @chatroom, user: system_user, content: ai_content)
    else
      Rails.logger.error("OpenAI Error: Response was empty or invalid.")
      nil
    end
  end

  def broadcast_message(message)
    return unless message

    ChatroomChannel.broadcast_to(
      @chatroom,
      message: render_to_string(partial: "message", locals: { message: message }),
      sender_id: message.user.id
    )
  end
end
