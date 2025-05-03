class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all
    Rails.logger.info("Here")
    render json: @users, each_serializer: UserSerializer, show_attempted_problems?: false
  end

  def show
    @user = User.where(id: params[:id]).first
    render json: @user, serializer: UserSerializer, show_attempted_problems?: true
  end
end
