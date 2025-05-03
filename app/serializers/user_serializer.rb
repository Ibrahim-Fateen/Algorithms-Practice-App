class UserSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :avatar_url, :solved_problems_count, :accuracy, :streak, :attempted_problems
  attribute :user_type, if: :as_admin?

  def user_type
    object.admin? ? 'admin' : 'user'
  end
  def solved_problems_count
    object.submissions.where(status: :passed).select('DISTINCT problem_id').count
  end

  def avatar_url
    'https://avatar.iran.liara.run/public/boy?username=Ash'
  end

  def accuracy
    return 0 if object.submissions.count.zero?

    (object.submissions.where(status: :passed).count.to_f / object.submissions.count * 100).round(2)
  end

  def streak
    streak = 0
    current_week_id = Week.where(posted: true).last.id
    while current_week_id >= 0
      current_week_problems = Problem.where(week_id: current_week_id)
      current_week_problems.each do |problem|
        current_week_submission = object.submissions.where(problem: problem).last
        if current_week_submission.nil? || current_week_submission.status != 'passed'
          return streak
        end
      end
      streak += 1
      current_week_id -= 1
    end
    streak
  end

  def attempted_problems
    return [] unless show_attempted_problems?
    object.attempted_problems.map do |problem|
      ProblemSerializer.new(problem, current_user: object).as_json
    end
  end

  def show_attempted_problems?
    @instance_options[:show_attempted_problems?]
  end

  def as_admin?
    @instance_options[:as_admin?] || false
  end
end
