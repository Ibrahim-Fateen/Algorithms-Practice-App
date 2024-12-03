# app/controllers/admin/weeks_controller.rb
module Admin
  class WeeksController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    before_action :set_week, only: [:edit, :update, :destroy]

    def index
      @weeks = Week.order(number: :asc)
    end

    def new
      @week = Week.new
    end

    def create
      @week = Week.new(week_params)
      if @week.save
        redirect_to admin_weeks_path, notice: 'Week created successfully.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @week.update(week_params)
        redirect_to admin_weeks_path, notice: 'Week updated successfully.'
      else
        render :edit
      end
    end

    def destroy
      @week.destroy
      redirect_to admin_weeks_path, notice: 'Week deleted successfully.'
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