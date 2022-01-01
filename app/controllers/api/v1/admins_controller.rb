class Api::V1::AdminsController < ApplicationController
  wrap_parameters false
  before_action :authenticate_admin, only: [:promote_learner, :update, :create]
  
  def create
    permited_params = signup_params
    ActiveRecord::Base.transaction do
      @user_auth = UserAuth.create!(email: permited_params[:email], password: permited_params[:password],
                                   password_confirmation: permited_params[:password_confirmation], user_name: permited_params[:user_name], role: role)
      @admin = Admin.create!(first_name: permited_params[:first_name], last_name: permited_params[:last_name],
                            birthday: permited_params[:birthday], user_auth_id: @user_auth.id, image: permited_params[:image])
    end
    @data = { name: "#{@admin.first_name} #{@admin.last_name}", email: @user_auth.email,
              user_name: @user_auth.user_name, birthday: @admin.birthday, image: @admin.image.url, type: @user_auth.role }
    render 'api/v1/shared/_create', status: :created
  end

  def promote_learner
    permited_params = promote_params
    ActiveRecord::Base.transaction do
      @user_auth = UserAuth.find_by!(user_name: permited_params[:user_name]) || UserAuth.find_by!(email: permited_params[:email])
      @learner = Learner.find_by!(user_auth: @user_auth) 
      @user_auth.update!(role: UserAuth.roles[:instructor])
      @instructor = Instructor.create!(first_name: @learner.first_name, last_name: @learner.last_name, birthday: @learner.birthday, image: @learner.image, user_auth: @user_auth)
    end
    render status: :created
  end
  
  def update
    permited_params = update_params
    if @user_auth.valid_password?(permited_params[:user_password])
      permited_params.delete('user_password')
      if @user_auth.admin.update!(permited_params)
        @user = { id: @user_auth.id, user_name: @user_auth.user_name, birthday: @user_auth.admin.birthday,
                  first_name: @user_auth.admin.first_name, last_name: @user_auth.admin.last_name }
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

  private

  def signup_params
    params.permit(:email, :password, :password_confirmation, :user_name, :first_name, :last_name, :birthday, :image)
  end

  def promote_params
    params.permit(:email, :user_name)
  end
  def update_params
    params.permit(:user_password, :first_name, :last_name, :birthday)
  end

  def role
    UserAuth.roles[:admin]
  end
end
