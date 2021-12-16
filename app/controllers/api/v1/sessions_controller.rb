class Api::V1::SessionsController < ApplicationController
  wrap_parameters false
  before_action :authenticate_any, only: [:current_user]
  def create
    permited_params = session_params
    @user_auth = UserAuth.where(email: permited_params[:email]).first
    if @user_auth
      if @user_auth.valid_password?(permited_params[:password])
        @user = @user_auth.get_user
        @data = { name: "#{@user.first_name} #{@user.last_name}", email: @user_auth.email,
                  user_name: @user_auth.user_name, birthday: @user.birthday }
        render  'api/v1/shared/_create', status: :ok
      else
        render 'api/v1/errors/incorrect_credentials', states: :unauthorized
      end
    else
        render 'api/v1/errors/user_not_found', status: :not_found
    end
  end

  def current_user
    render status: :ok
  end
  private
  def session_params
    params.permit(:email, :password)
  end
end
