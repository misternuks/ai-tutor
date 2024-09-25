class AddPermittedClassCodesToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :permitted_class_codes, :string, array: true, default: []
  end
end
