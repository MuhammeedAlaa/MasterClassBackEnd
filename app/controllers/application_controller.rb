class ApplicationController < ActionController::API
  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  def authenticate_any
    authenticate(roles: [])
  end
  
  def authenticate_admin_instructor
    authenticate(roles: [UserAuth.roles[:admin], UserAuth.roles[:instructor]])
  end
  def authenticate_admin
    authenticate(roles: [UserAuth.roles[:admin]])
  end

  def authenticate_learner
    authenticate(roles: [UserAuth.roles[:learner]])
  end
  
  def authenticate_instructor
    authenticate(roles: [UserAuth.roles[:instructor]])
  end

  def authenticate(roles: [])
    if request.headers['Authorization'].present?
      begin
        decode_token
        if !roles.empty? && !roles.include?(UserAuth.roles[@user_auth.role])
          render json: {
            "status": 'error',
            "errors": [
              {
                "name": 'Unauthorized',
                "message": 'Un authorized request'
              }
            ]
          }, status: :unauthorized
        end
        @user = @user_auth.get_user
        @user = { name: "#{@user.first_name} #{@user.last_name}", email: @user_auth.email,
                  user_name: @user_auth.user_name, birthday: @user.birthday }
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => e
        render json: {
          "status": 'error',
          "errors": [
            {
              "name": e.to_s,
              "message": e.message.to_s
            }
          ]
        }, status: :unauthorized
      rescue StandardError => e
        render json: {
          "status": 'error',
          "errors": [
            {
              "name": e.to_s,
              "message": e.message.to_s
            }
          ]
        }, status: :internal_server_error
      end
    else
      render json: {
        "status": 'error',
        "errors": [
          {
            "name": 'NoAuthorizationSent',
            "message": 'No authorization header sent'
          }
        ]
      }, status: :forbidden

    end
  end
  rescue_from ActiveRecord::RecordNotFound do
    render json: {
      status: 'error',
      errors: [
        {
          title: 'RecordNotFound',
          message: 'Not found'
        }
      ]
    }, status: :not_found
  end
  rescue_from ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid do |exception|
    render json: {
      status: 'error',
      errors: [
        {
          title: 'Invalid Record',
          message: exception.record.errors
        }
      ]
    }, status: :unprocessable_entity
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render json: {
      status: 'error',
      errors: [
        {
          title: 'Missing Parameter',
          message: exception.message
        }
      ]
    }, status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotUnique do |exception|
    render json: {
      status: 'error',
      errors: [
        {
          title: 'Not Unique',
          message: exception.message
        }
      ]
    }, status: :bad_request
  end

  private

  def decode_token
    token = request.headers['Authorization'].split(' ')[1]
    payload = JWT.decode(token, secret).first
    user_id = payload['id']
    @user_auth = UserAuth.find_by_id!(user_id)
  end

  def secret
    ENV['JWT_SECRET']
  end

  def create_token(payload)
    JWT.encode(payload, secret)
  end
end
