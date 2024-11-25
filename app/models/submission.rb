class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :problem

  enum status: { pending: 0, running: 1, passed: 2, failed: 3, error: 4 }

  validates :code, presence: true
end