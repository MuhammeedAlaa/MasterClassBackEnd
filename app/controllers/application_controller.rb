class ApplicationController < ActionController::API
  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  def authenticate_any
    authenticate(roles: [])
  end
  def authenticate(roles: [])
    @auth_header = request.headers["Authorization"]
    if @auth_header
      begin
        decoded_token = JWT.decode(token, secret)
        payload = decoded_token.first
        user_id = payload["id"]
        @user_auth = UserAuth.find_by_id!(user_id)
        unless roles.empty?
          unless roles.include?(UserAuth.roles[@user_auth.role])
            render json: {
              "status": "error",
              "errors": [
                {
                  "name": "Unauthorized",
                  "message": "Un authorized request",
                },
              ],
            }, status: :unauthorized
          end
        end

        @user = @user_auth.get_user

        @user = {id: @user.id, name: @user.name}
      rescue => e
        render json: {
          "status": "error",
          "errors": [
            {
              "name": "#{e}",
              "message": "#{e.message}",
            },
          ],
        }, status: :internal_server_error
      end
    else
      render json: {
        "status": "error",
        "errors": [
          {
            "name": "NoAuthorizationSent",
            "message": "No authorization header sent",
          },
        ],
      }, status: :forbidden
    end
  end
  def secret
    ENV["JWT_SECRET"]
  end
  def create_token(payload)
    JWT.encode(payload, secret)
  end
  def token
    @auth_header.split(" ")[1]
  end
  rescue_from ActiveRecord::RecordNotFound do
  render json: {
      status: "error",
      errors: [
        {
          title: "RecordNotFound",
          message: "Not found",
        },
      ],
    }, status: :not_found
  end
  rescue_from ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid do |exception|
    render json: {
      status: "error",
      errors: [
        {
          title: "Invalid Record",
          message: exception.record.errors,
        },
      ],
    }, status: :unprocessable_entity
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render json: {
      status: "error",
      errors: [
        {
          title: "Missing Parameter",
          message: exception.message,
        },
      ],
    }, status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotUnique do |exception|
    render json: {
      status: "error",
      errors: [
        {
          title: "Not Unique",
          message: exception.message
        }
      ],
    },  status: :bad_request
  end
end
