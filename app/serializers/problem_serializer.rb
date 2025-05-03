class ProblemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :difficulty, :week_id, :template_code, :global_trials, :global_passed
  attributes :acceptance_rate, :hints, :test_cases, :user_state, :last_submitted

  has_many :hints, serializer: HintSerializer
  has_many :test_cases, serializer: TestCaseSerializer

  def test_cases
    object.test_cases.where(is_hidden: false)
  end

  def user_state
    if current_user.nil?
      return "None"
    end
    object.submissions.where(user: current_user).last&.status || "Not Attempted"
  end

  def last_submitted
    last_submission = object.submissions.where(user: current_user).last
    return "Not Attempted" if last_submission.nil?
    time_ago_in_words(last_submission.created_at)
  end

  def time_ago_in_words(time)
    time_ago = (Time.now - time).to_i
    return "just now" if time_ago < 60
    return "#{time_ago / 60} minutes ago" if time_ago < 3600
    return "#{time_ago / 3600} hours ago" if time_ago < 86400
    "#{time_ago / 86400} days ago"
  end

  def acceptance_rate
    total_submissions = object.submissions.count
    total_submissions.positive? ? (object.submissions.passed.count.to_f / total_submissions) : 0.0
  end

  def global_trials
    object.submissions.count
  end

  def global_passed
    object.submissions.passed.count
  end

  def current_user
    @instance_options[:current_user]
  end
end