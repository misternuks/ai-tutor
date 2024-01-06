class Chatroom < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  has_many :messages, dependent: :destroy
end
