class Api::V1::LearnersController < ApplicationController
  wrap_parameters false
  before_action :authenticate_any, only: %i[update]
  before_action :authenticate_admin, only: [:getAll]
  include Paginate
  def create
    permited_params = signup_params
    ActiveRecord::Base.transaction do
      @user_auth = UserAuth.create!(email: permited_params[:email], password: permited_params[:password],
                                    password_confirmation: permited_params[:password_confirmation], user_name: permited_params[:user_name], role: role)
      @learner = Learner.create!(first_name: permited_params[:first_name], last_name: permited_params[:last_name],
                                 birthday: permited_params[:birthday], user_auth_id: @user_auth.id, image: permited_params[:image])
    end
    @data = { name: "#{@learner.first_name} #{@learner.last_name}", email: @user_auth.email,
              user_name: @user_auth.user_name, birthday: @learner.birthday, image: request.base_url + @learner.image.url }
    render 'api/v1/shared/_create', status: :created
  end

  def update
    permited_params = update_params
    @user = UserAuth.find_by!(user_name: permited_params[:user_name])
    if @user.user_name != @user_auth.user_name && @user_auth.role != 'admin'
      render json: {
        "status": 'error',
        "errors": [
          {
            "name": 'Unauthorized',
            "message": 'Un authorized request'
          }
        ]
      }, status: :unauthorized
    elsif @user_auth.valid_password?(permited_params[:user_password])
      permited_params.delete('user_password')
      permited_params.delete('user_name')
      if @user.learner.update!(permited_params)
        @user = { id: @user.id, user_name: @user.user_name, birthday: @user.learner.birthday,
                  first_name: @user.learner.first_name, last_name: @user.learner.last_name }
        render status: :ok
      else
        render 'api/v1/errors/invalid_user_data', status: :bad_request
      end
    else
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
  end

  def getAll
      @limit, @offset, @page = pagination_params
      @learners = Learner.includes(:user_auth).all.limit(@limit).offset(@offset)
      puts @learners.inspect
      @learnersCount = Learner.all.count
      render json: {
      "status": 'success',
      "data": {
        "count": @learnersCount,
        "learners": @learners
      }
    }, status: :ok
  end

  private

  def signup_params
    params.permit(:email, :password, :password_confirmation, :user_name, :first_name, :last_name, :birthday, :image)
  end

  def update_params
    params.permit(:user_password, :user_name, :first_name, :last_name, :birthday)
  end

  def role
    UserAuth.roles[:learner]
  end
end
