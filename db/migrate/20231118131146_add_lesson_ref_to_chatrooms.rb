class AddLessonRefToChatrooms < ActiveRecord::Migration[7.1]
  def change
    add_reference :chatrooms, :lesson, foreign_key: true
  end
end
