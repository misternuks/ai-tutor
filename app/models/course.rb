class Course < ApplicationRecord
  belongs_to :user
  has_many :units, dependent: :destroy
  validates :name, presence: true
end
