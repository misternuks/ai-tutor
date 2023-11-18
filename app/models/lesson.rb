class Lesson < ApplicationRecord
  belongs_to :unit
  has_many :chatrooms
end
