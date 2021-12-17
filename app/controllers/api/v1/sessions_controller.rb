# frozen_string_literal: true

# class for sessions
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
  def forget
    @user = UserAuth.find_by(email: reset_params[:email])
    if @user.present?
      UserAuthMailer.with(user: @user).reset.deliver_later
      render json: {
        'status': 'success',
        'data': [
          {
            'message': 'An email was send to you succesfully!'
          }
        ]
      }, status: :ok
    else
      render 'api/v1/errors/user_not_found', status: :not_found
    end
  end

  def reset
    update_p = update_password_params
    @user = UserAuth.find_signed!(update_p[:token], purpose: "password_reset")
    if @user.update!(password: update_p[:password], password_confirmation: update_p[:password_confirmation])
     render json: {
        'status': 'success',
        'data': [
          {
            'message': 'password has been updated succesfully!'
          }
        ]
      }, status: :no_content
    else
      render json: {
        'status': 'error',
        'data': [
          {
            'message': "Password doesn't match password confirmation"
          }
        ]
      }, status: :bad_request
    
    end

  rescue ActiveSupport::MessageVerifier::InvalidSignature
    render 'api/v1/errors/invalid_reset_password_token', status: :unauthorized
  end

  private

  def session_params
    params.permit(:email, :password)
  end

  def reset_params
    params.permit(:email)
  end
  def update_password_params
    params.permit(:password, :password_confirmation, :token)
  end
end
