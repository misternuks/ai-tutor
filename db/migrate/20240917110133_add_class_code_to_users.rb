class AddClassCodeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :class_code, :string
  end
end
