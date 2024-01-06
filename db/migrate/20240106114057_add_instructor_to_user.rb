class AddInstructorToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :instructor, :boolean, default: false
  end
end
