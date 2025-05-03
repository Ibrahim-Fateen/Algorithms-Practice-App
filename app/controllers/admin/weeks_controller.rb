module Admin
  class WeeksController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    before_action :set_week, only: [:update, :destroy, :publish]

    def index
      @weeks = Week.order(number: :asc)
      render json: @weeks, each_serializer: WeekSerializer
    end

    def create
      @week = Week.new(week_params)
      if @week.save
        render json: @week, serializer: WeekSerializer
      else
        render json: { error: 'Failed to create week' }, status: :unprocessable_entity
      end
    end

    def update
      if @week.update(week_params)
        render json: @week, serializer: WeekSerializer
      else
        render json: { error: 'Failed to update week' }, status: :unprocessable_entity
      end
    end

    def destroy
      if @week.destroy
        render json: { message: 'Week deleted successfully.' }
      else
        render json: { error: 'Failed to delete week' }, status: :unprocessable_entity
      end
    end

    def publish
      if @week.publish!
        render json: @week, serializer: WeekSerializer
      else
        render json: { error: 'Failed to publish week' }, status: :unprocessable_entity
      end
    end

    def upcoming
      @weeks = Week.upcoming
      render json: @weeks, each_serializer: WeekSerializer
    end

    def past
      @weeks = Week.past
      render json: @weeks, each_serializer: WeekSerializer
    end

    private

    def require_admin
      redirect_to root_path, alert: 'Unauthorized access.' unless current_user.admin?
    end

    def set_week
      @week = Week.find(params[:id])
    end

    def week_params
      params.require(:week).permit(:number, :theme)
    end
  end
end