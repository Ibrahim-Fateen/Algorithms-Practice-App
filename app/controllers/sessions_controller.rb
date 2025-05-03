class SessionsController < Devise::SessionsController
  include ActionController::MimeResponds
  respond_to :json

  def create
    super do |resource|
      render json: {
        status: {
          code: 200,
          message: 'Logged in successfully',
          token: current_token
        },
        data: resource
      } and return
    end
  end

  def destroy
    # Ensure the user is signed in
    if current_user
      # Perform sign out
      sign_out(current_user)

      # Respond with JSON
      render json: {
        status: {
          code: 200,
          message: 'Logged out successfully'
        }
      }, status: :ok
    else
      render json: {
        status: {
          code: 400,
          message: 'No active session found'
        }
      }, status: :bad_request
    end
  end

  def respond_to_on_destroy
    respond_to do |format|
      format.json {
        render json: {
          status: {
            code: 200,
            message: 'Logged out successfully'
          }
        }, status: :ok
      }
    end
  end

  private

  def current_token
    request.env['warden-jwt_auth.token']
  end
end
