module Admin
  class ProblemsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    before_action :set_problem, only: [:edit, :update, :destroy]

    def index
      @problems = Problem.all
    end

    def new
      @problem = Problem.new
      @problem.hints.build
      @problem.test_cases.build
      @problem.build_solution
    end

    def create
      @problem = Problem.new(problem_params)
      if @problem.save
        redirect_to admin_problems_path, notice: 'Problem created successfully.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @problem.update(problem_params)
        redirect_to admin_problems_path, notice: 'Problem updated successfully.'
      else
        render :edit
      end
    end

    def destroy
      @problem.destroy
      redirect_to admin_problems_path, notice: 'Problem deleted successfully.'
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