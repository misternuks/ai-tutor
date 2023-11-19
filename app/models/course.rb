class Course < ApplicationRecord
  belongs_to :user
  has_many :units

  validates :name, presence: true
end
