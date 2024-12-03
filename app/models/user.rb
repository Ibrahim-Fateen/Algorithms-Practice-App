class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :submissions
  has_many :problems, through: :submissions

  def admin?
    admin == true
  end
end
