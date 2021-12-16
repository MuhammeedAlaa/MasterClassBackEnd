class Api::V1::LearnersController < ApplicationController
  wrap_parameters false
  def create
    permited_params = signup_params
    ActiveRecord::Base.transaction do
      @user_auth = UserAuth.create(email: permited_params[:email], password: permited_params[:password],
                              password_confirmation: permited_params[:password_confirmation], user_name: permited_params[:user_name], role: role)
      @learner = Learner.create(first_name: permited_params[:first_name], last_name: permited_params[:last_name],
                                 birthday: permited_params[:birthday], user_auth_id: @user_auth.id)
    end
    @data = { name: "#{@learner.first_name} #{@learner.last_name}", email: @user_auth.email,
                  user_name: @user_auth.user_name, birthday: @learner.birthday }
    render 'api/v1/shared/_create' ,status: :created
  end

  private

  def signup_params
    params.permit(:email, :password, :password_confirmation, :user_name, :first_name, :last_name, :birthday)
  end

  def role
    UserAuth.roles[:learner]
  end
end
