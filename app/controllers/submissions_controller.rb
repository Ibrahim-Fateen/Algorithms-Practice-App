class SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_problem, only: [:new, :create]

  def new
    @submission = current_user.submissions.build(problem: @problem)
    # Get the previous submission if it exists
    @previous_submission = current_user.submissions
                                       .where(problem: @problem)
                                       .order(created_at: :desc)
                                       .first
  end

  def create
    @submission = current_user.submissions.build(submission_params)
    @submission.problem = @problem
    @submission.status = 'pending'

    if @submission.save
      # We'll implement the code execution service later
      # CodeExecutionJob.perform_later(@submission.id)

      respond_to do |format|
        format.html { redirect_to problem_path(@problem), notice: 'Solution submitted successfully!' }
        format.json { render json: {
          status: @submission.status,
          message: 'Solution submitted successfully!'
        } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @submission = current_user.submissions.find(params[:id])
  end

  private

  def set_problem
    @problem = Problem.find(params[:problem_id])
  end

  def submission_params
    params.require(:submission).permit(:code, :problem_id)
  end
end