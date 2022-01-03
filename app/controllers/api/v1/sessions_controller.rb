# frozen_string_literal: true

# class for sessions
class Api::V1::SessionsController < ApplicationController
  
  wrap_parameters false
  before_action :authenticate_any, only: [:current_user, :update]


  def create
    permited_params = session_params
    @user_auth = UserAuth.where(email: permited_params[:email]).first
    if @user_auth
      if @user_auth.valid_password?(permited_params[:password])
        @user = @user_auth.get_user
        @data = { name: "#{@user.first_name} #{@user.last_name}", email: @user_auth.email,
                  user_name: @user_auth.user_name, birthday: @user.birthday, type: @user_auth.role, image: @user.image_url}
        render  'api/v1/shared/_create', status: :ok
      else
        render 'api/v1/errors/incorrect_credentials', status: :unauthorized
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
    @user_auth = UserAuth.find_signed!(update_p[:token], purpose: "password_reset")
    if @user_auth.update!(password: update_p[:password], password_confirmation: update_p[:password_confirmation])
      @user = @user_auth.get_user
      @data = { name: "#{@user.first_name} #{@user.last_name}", email: @user_auth.email,
                  user_name: @user_auth.user_name, birthday: @user.birthday, type: @user_auth.role, image: @user.image_url}
      render  'api/v1/shared/_create', status: :ok
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

  def update
    permited_params = update_params
    @user = UserAuth.find_by!(user_name: permited_params[:old_user_name])
    if @user.user_name != @user_auth.user_name
      if @user_auth.role != 'admin' || (@user_auth.role == 'admin' && @user.role == 'admin')
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
    else
      if @user_auth.valid_password?(permited_params[:user_password])
        permited_params.delete("user_password")
        permited_params.delete("old_user_name")
        if @user.update!(permited_params)
          @user = {id: @user.id, email: @user.email, user_name: @user.user_name}
          render status: :ok
        else
          render 'api/v1/errors/invalid_user_data',status: :bad_request
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
  end

  private

  def session_params
    params.permit(:email, :password)
  end

  def reset_params
    params.permit(:email)
  end
  def update_params
    params.permit(:email, :user_password, :user_name, :old_user_name, :password)
  end
  def update_password_params
    params.permit(:password, :password_confirmation, :token)
  end
end
