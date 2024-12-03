class TestCase < ApplicationRecord
  belongs_to :problem

  validates :input, presence: true
  validates :expected_output, presence: true

  def self.for_problem(problem)
    where(problem_id: problem.id)
      .select(:input, :expected_output)
      .map { |tc| { input: tc.input, output: tc.expected_output } }
  end
end