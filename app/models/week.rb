class Week < ApplicationRecord
  has_many :problems

  validates :number, presence: true, uniqueness: true

  def self.current
    where(number: Date.today.strftime('%U').to_i).first_or_create
  end
end