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

  accepts_nested_attributes_for :hints,
                                reject_if: :all_blank,
                                allow_destroy: true

  accepts_nested_attributes_for :test_cases,
                                reject_if: :all_blank,
                                allow_destroy: true

  accepts_nested_attributes_for :solution,
                                reject_if: :all_blank
end