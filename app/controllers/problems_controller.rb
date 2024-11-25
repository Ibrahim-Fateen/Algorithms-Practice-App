class ProblemsController < ApplicationController
  before_action :authenticate_user!
  def index
    @weeks = Week.all.order(:number)
    @current_week = if params[:week_id]
                      Week.find(params[:week_id])
                    else
                      Week.order(:number).first
                    end

    @problems = @current_week.problems.order(:difficulty)
  end

  def show
    @problem = Problem.find(params[:id])
    @submission = Submission.new
  end
end