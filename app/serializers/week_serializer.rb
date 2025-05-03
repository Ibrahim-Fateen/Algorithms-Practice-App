class WeekSerializer < ActiveModel::Serializer
  attributes :id, :number, :theme, :problems
  attribute :fastest_solver, if: :with_winners?
  attribute :highest_accuracy, if: :with_winners?
  attribute :posted, if: :as_admin?

  def fastest_solver
    object.fastest_solver
  end

  def highest_accuracy
    object.highest_accuracy
  end

  def with_winners?
    @instance_options[:with_winners?] || false
  end

  def as_admin?
    @instance_options[:as_admin?] || false
  end

  def problems
    object.problems.map do |problem|
      ProblemSerializer.new(problem, current_user: current_user).as_json
    end
  end
end