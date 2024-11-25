class Problem < ApplicationRecord
  belongs_to :week
  has_many :submissions
  has_many :test_cases
  has_many :hints
  has_one :solution

  validates :title, presence: true
  validates :description, presence: true
  validates :difficulty, presence: true
  validates :template_code, length: { maximum: 5000 }, allow_blank: true

  enum difficulty: { easy: 'Easy', medium: 'Medium', hard: 'Hard' }

  scope :current_week, -> { where(week: Week.current) }
end