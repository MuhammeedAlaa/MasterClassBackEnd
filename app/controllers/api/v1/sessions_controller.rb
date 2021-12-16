class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_any, only: [:current_user]
  def create
    @user = UserAuth.where(email: params[:email]).first
    if @user
      if @user.valid_password?(session_params[:password])
        exp = Time.now.to_i + ENV["JWT_EXP_DATE"].to_i
        @payload = { id: @user.id, exp: exp }
        @token = 'Bearer ' + create_token(@payload)
        @data = {
                  id: @user.id, 
                  email: @user.email
                }
        render status: :ok
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
