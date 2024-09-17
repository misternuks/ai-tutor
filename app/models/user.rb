class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :courses
  has_many :chatrooms

  validates :email, uniqueness: true
  validates :class_code, presence: true, format: { with: /\A\d{4}\z/, message: "must be exactly four digits." }

end
