class SubmissionSerializer < ActiveModel::Serializer
  attributes :id, :code, :status, :created_at, :problem_id, :problem_title, :problem_difficulty

  def problem_title
    object.problem.title
  end

  def problem_difficulty
    object.problem.difficulty
  end
end