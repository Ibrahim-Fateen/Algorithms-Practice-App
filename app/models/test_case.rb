class TestCase < ApplicationRecord
  belongs_to :problem

  validates :input, presence: true
  validates :expected_output, presence: true
end