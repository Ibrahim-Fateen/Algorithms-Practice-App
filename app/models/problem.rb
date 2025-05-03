class Problem < ApplicationRecord
  belongs_to :week
  has_many :submissions, dependent: :destroy
  has_many :test_cases, dependent: :destroy
  has_many :hints, dependent: :destroy
  has_one :solution, dependent: :destroy

  attr_accessor :global_trials, :global_passed

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