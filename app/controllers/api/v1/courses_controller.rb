class Api::V1::CoursesController < ApplicationController
  wrap_parameters false
  before_action :authenticate_admin_instructor, only: [:create]
  before_action :authenticate_any, only: [:courses]
  include Paginate
  def create
    permited_params = create_course_params
    @course = Course.create!(name: permited_params[:name], user_auth: @user_auth)
    @data = { name: "#{@course.name}", course_id: @course.id, email: @user_auth.email, user_name: @user_auth.user_name}
    render status: :created
  end

  def courses
    @limit, @offset, @page = pagination_params
    puts @offset
    @courses = Course.all.select('id', 'name').limit(@limit).offset(@offset)
    @total = Course.all.count
    @count = @courses.count
    render status: :ok
  end

  private

  def create_course_params
    params.permit(:name)
  end

end
