class Api::V1::CoursesController < ApplicationController
  wrap_parameters false
  before_action :authenticate_admin_instructor, only: [:create]
  def create
    permited_params = create_course_params
    ActiveRecord::Base.transaction do
      @course = Course.create!(name: permited_params[:name], user_auth: @user_auth)
    end
    @data = { name: "#{@course.name}", email: @user_auth.email, user_name: @user_auth.user_name}
    render status: :created
  end

  private

  def create_course_params
    params.permit(:name)
  end

end
