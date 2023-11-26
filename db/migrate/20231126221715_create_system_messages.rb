class CreateSystemMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :system_messages do |t|
      t.text :content

      t.timestamps
    end
  end
end
