require 'csv'

class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  def self.to_csv
    attributes = ['Course Name', 'Unit Name', 'Lesson Name', 'Username', 'Content', 'Created At']

    CSV.generate(headers: true) do |csv|
      csv << attributes

      # Use an array for multiple associations
      all.includes([:user, chatroom: { lesson: { unit: :course } }]).find_each do |message|
        csv << [
          message.chatroom&.lesson&.unit&.course&.name,  # Course name
          message.chatroom&.lesson&.unit&.name,          # Unit name
          message.chatroom&.lesson&.name,                # Lesson name
          message.user&.username,                        # Username from user association
          message.content,                               # Message content
          message.created_at                             # Message timestamp
        ]
      end
    end
  end
end
