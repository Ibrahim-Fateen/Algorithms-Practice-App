class DashboardController < ApplicationController
  def index
    @submissions = current_user.submissions.includes(:problem)
                               .order(created_at: :desc)
    @solved_problems = current_user.submissions
                                   .where(status: :passed)
                                   .select('DISTINCT problem_id')
                                   .count
    render json: { submissions: @submissions, solved_problems: @solved_problems }
  end
end