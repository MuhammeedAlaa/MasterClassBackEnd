class Api::V1::CoursesController < ApplicationController
  wrap_parameters false
  before_action :authenticate_admin_instructor, only: [:create, :activity]
  before_action :authenticate_any, only: [:courses, :course]
  include Paginate
  def create
    permited_params = create_course_params
    @course = Course.create!(name: permited_params[:name], user_auth: @user_auth)
    @data = { name: "#{@course.name}", course_id: @course.id, creator_user_name: @user_auth.user_name}
    render status: :created
  end

  def courses
    @limit, @offset, @page = pagination_params
    @courses = Course.all.select('id', 'name').limit(@limit).offset(@offset)
    @total = Course.all.count
    @count = @courses.count
    render status: :ok
  end
  
  def course
    @course = Course.find(course_params[:id])
    render status: :ok
  end

  def activity
    permited_params = activity_params
    @course = Course.find(permited_params[:course_id])
    if !permited_params[:link] && !permited_params[:document_data]
      render 'api/v1/errors/unprocessable_entity', status: :bad_request
    else
      if permited_params[:document_data]
        ActiveRecord::Base.transaction do
          permited_params[:document_data].each do |file|
            Activity.create!(:document => file, course: @course, name: permited_params[:name])
          end
        end
      end
      if permited_params[:link]
        ActiveRecord::Base.transaction do
          permited_params[:link].each do |youtube_link|
          Activity.create!(course: @course, name: permited_params[:name], :link => youtube_link)
          end
        end
      end
      render status: :created   
    end 
  end

  private

  def activity_params
    params.permit(:course_id, :name, :link => [] ,:document_data => [])
  end
  def create_course_params
    params.permit(:name)
  end
  def course_params
    params.permit(:id)
  end

end
