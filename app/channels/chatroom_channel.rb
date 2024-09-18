class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    chatroom = Chatroom.find(params[:id])
    stream_for chatroom
    # stream_from "some_channel"
  end

  def broadcast_message(message)
    return unless message

    ChatroomChannel.broadcast_to(
      @chatroom,
      message: render_to_string(partial: "message", locals: { message: message }),
      sender_id: message.user.id,
      chatroom_full: @chatroom.full
    )
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
