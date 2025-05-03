class SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_problem, only: [:new, :create]

  def index
    @submissions = current_user.submissions.order(created_at: :desc)
    render json: @submissions, each_serializer: SubmissionSerializer
  end

  def create
    @submission = current_user.submissions.build(submission_params)
    @submission.problem = @problem
    @submission.status = 'pending'

    if @submission.save
      CodeExecutionJob.perform_later(@submission.id)
      render json: @submission
    else
      render json: { errors: @submission.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @submission = current_user.submissions.find(params[:id])
    render json: @submission, serializer: SubmissionSerializer
  end

  private

  def set_problem
    @problem = Problem.find(params[:problem_id])
  end

  def submission_params
    params.require(:submission).permit(:code, :problem_id)
  end
end