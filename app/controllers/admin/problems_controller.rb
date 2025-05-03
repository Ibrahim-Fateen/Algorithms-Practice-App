module Admin
  class ProblemsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    before_action :set_problem, only: [:edit, :update, :destroy, :edit]

    def index
      @problems = Problem.all
      render json: @problems, each_serializer: ProblemSerializer, current_user: current_user
    end

    def create
      @problem = Problem.new(problem_params)
      if @problem.save
        render json: @problem
      end
    end

    def update
      @problem.hints.destroy_all
      @problem.test_cases.destroy_all
      @problem.solution&.destroy

      if @problem.update(problem_params)
        render json: @problem
      else
        render json: { errors: @problem.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def edit
      render json: @problem
    end

    def destroy
      if @problem.destroy
        render json: { message: 'Problem deleted successfully.' }
      else
        render json: { errors: @problem.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def require_admin
      redirect_to root_path, alert: 'Unauthorized access.' unless current_user.admin?
    end

    def set_problem
      @problem = Problem.find(params[:id])
    end

    def problem_params
      params.require(:problem).permit(
        :title, :description, :difficulty, :week_id,
        :template_code, :stress_test_code,
        hints_attributes: [:id, :content, :order_number, :_destroy],
        test_cases_attributes: [:id, :input, :expected_output, :is_hidden, :_destroy],
        solution_attributes: [:id, :code, :time_complexity, :space_complexity, :_destroy]
      )
    end
  end
end