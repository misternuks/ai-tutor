class Lesson < ApplicationRecord
  belongs_to :unit
  has_many :chatrooms
  # accepts_nested_attributes_for :chatrooms
  validates :name, presence: true
end
