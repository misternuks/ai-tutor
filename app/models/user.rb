class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :courses
  has_many :chatrooms

  validates :email, uniqueness: true, format: { with: /(kuis.ac.jp)|(icu.ac.jp)|(euan.bonner@gmail.com)|(misternuks@gmail.com)/, message: "You must use a valid student or teacher email address." }
  validates :class_code, presence: true, format: { with: /\A\d{4}\z/, message: "must be exactly four digits." }

end
