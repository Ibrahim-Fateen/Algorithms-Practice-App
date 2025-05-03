# class RegistrationsController < Devise::RegistrationsController
#   def create
#     build_resource(sign_up_params)
#
#     if resource.save
#       # For token-based auth, don't use sign_in
#       render json: {
#         status: {
#           code: 200,
#           message: 'Signed up successfully',
#           data: resource
#         }
#       }, status: :ok
#     else
#       clean_up_passwords resource
#       set_minimum_password_length
#       render json: {
#         status: {
#           code: 422,
#           message: 'Sign up failed',
#           errors: resource.errors.full_messages
#         }
#       }, status: :unprocessable_entity
#     end
#   end
#
#   private
#
#   def sign_up_params
#     params.require(:user).permit(:email, :password, :password_confirmation, :nickname)
#   end
# end
class RegistrationsController < Devise::RegistrationsController
  include ActionController::MimeResponds
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil)
      render json: {
        status: {
          code: 200,
          message: 'Signed up successfully',
          token: token.first
        },
        data: resource
      }, status: :created
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: {
        status: {
          code: 422,
          message: 'Sign up failed',
          errors: resource.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  private

  def current_token
    request.env['warden-jwt_auth.token']
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :nickname)
  end
end