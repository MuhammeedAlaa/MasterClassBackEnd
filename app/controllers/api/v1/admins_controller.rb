class Api::V1::AdminsController < ApplicationController
  wrap_parameters false
  before_action :authenticate_admin, only: [:promote_learner]
  def create
    permited_params = signup_params
    ActiveRecord::Base.transaction do
      @user_auth = UserAuth.create(email: permited_params[:email], password: permited_params[:password],
                                   password_confirmation: permited_params[:password_confirmation], user_name: permited_params[:user_name], role: role)
      @admin = Admin.create(first_name: permited_params[:first_name], last_name: permited_params[:last_name],
                            birthday: permited_params[:birthday], user_auth_id: @user_auth.id)
    end
    @data = { name: "#{@admin.first_name} #{@admin.last_name}", email: @user_auth.email,
              user_name: @user_auth.user_name, birthday: @admin.birthday }
    render 'api/v1/shared/_create', status: :created
  end

  def promote_learner
    permited_params = promote_params
    ActiveRecord::Base.transaction do
      @user_auth = UserAuth.find_by!(user_name: permited_params[:user_name]) || UserAuth.find_by!(email: permited_params[:email])
      @user_auth.update!(role: UserAuth.roles[:instructor])
    end
    render status: :created
  end

  private

  def signup_params
    params.permit(:email, :password, :password_confirmation, :user_name, :first_name, :last_name, :birthday)
  end

  def promote_params
    params.permit(:email, :user_name)
  end

  def role
    UserAuth.roles[:admin]
  end
end
