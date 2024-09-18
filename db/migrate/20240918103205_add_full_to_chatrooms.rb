class AddFullToChatrooms < ActiveRecord::Migration[7.1]
  def change
    add_column :chatrooms, :full, :boolean
  end
end
