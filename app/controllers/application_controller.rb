class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  before_action :authenticate_user!, except: [:new, :create]

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  unless Rails.env.development?
    rescue_from Exception do |exception|
      if exception.message.include?('unauthorized') ||
        exception.is_a?(Warden::UnauthorizedError)
        render json: { error: 'Unauthorized access' }, status: :unauthorized
      else
        raise exception
      end
    end
  end
end
