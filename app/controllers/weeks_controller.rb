class WeeksController < ApplicationController
  def index
    @weeks = Week.published.order(number: :asc)
    render json: @weeks, each_serializer: WeekSerializer
  end

  def show
    @week = Week.find(params[:id])
    if @week.posted?
      render json: @week, serializer: WeekSerializer
    else
      render json: { error: 'Week not found' }, status: :not_found
    end
  end
end