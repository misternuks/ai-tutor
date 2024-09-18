class Chatroom < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  has_many :messages, dependent: :destroy

  def total_messages_characters
    messages.sum { |m| m.content.length }
  end

  def check_full!
    if total_messages_characters >= 4000
      update(full: true)
    end
  end
end
