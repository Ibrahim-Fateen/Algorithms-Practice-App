class ProblemsController < ApplicationController
  before_action :authenticate_user!
  def index
    if params[:week_id]
      @problems = Week.find(params[:week_id]).problems
    else
      @problems = Problem.all
    end

    render json: @problems, each_serializer: ProblemSerializer, current_user: current_user
  end

  def show
    @problem = Problem.find(params[:id])
    render json: @problem, serializer: ProblemSerializer, current_user: current_user
  end
end