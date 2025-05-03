class WinnersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    week = Week.where(id: params[:week_id]).first || Week.current
    render json: {
      highest_accuracy: UserSerializer.new(week.highest_accuracy, show_attempted_problems?: false),
      fastest_solver: UserSerializer.new(week.fastest_solver, show_attempted_problems?: false)
    }
  end
end