class Course < ApplicationRecord
  belongs_to :user
  has_many :units
  # accepts_nested_attributes_for :units
  validates :name, presence: true
end
