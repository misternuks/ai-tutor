class Chatroom < ApplicationRecord
  belongs_to :lesson
  has_many :messages, dependent: :destroy
end
