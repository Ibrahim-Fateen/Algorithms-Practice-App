class Solution < ApplicationRecord
  belongs_to :problem

  validates :code, presence: true
  validates :problem_id, uniqueness: true  # Ensures one solution per problem
  validates :time_complexity, presence: true
  validates :space_complexity, presence: true
end