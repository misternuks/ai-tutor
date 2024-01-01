class Lesson < ApplicationRecord
  belongs_to :unit
  has_many :chatrooms, dependent: :destroy
  # accepts_nested_attributes_for :chatrooms
  validates :name, presence: true
end
