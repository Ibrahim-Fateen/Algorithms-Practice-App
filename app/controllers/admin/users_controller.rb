module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    before_action :set_user, only: [:edit, :update, :destroy]

    def index
      @users = User.all
      render json: @users, each_serializer: UserSerializer, as_admin?: true
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.admin = true
      if @user.save
        redirect_to admin_users_path, notice: 'Admin user created successfully.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      # if @user.update(user_params)
      #   redirect_to admin_users_path, notice: 'Admin user updated successfully.'
      # else
      #   render :edit
      # end

    end

    def destroy
      @user.destroy
      render json: { status: 'User deleted successfully' }
    end

    private

    def require_admin
      redirect_to root_path, alert: 'Unauthorized access.' unless current_user.admin?
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end