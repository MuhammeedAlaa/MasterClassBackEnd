class Api::V1::CoursesController < ApplicationController
  wrap_parameters false
  before_action :authenticate_admin_instructor, only: %i[create activity]
  before_action :authenticate_any, only: %i[courses course activities enroll]
  include Paginate
  def create
    permited_params = create_course_params
    @image = permited_params[:image] || Rails.root.join('public/images/fallback/courses/default.png').open
    @course = Course.create!(name: permited_params[:name], user_auth: @user_auth, image: @image,
                             about: permited_params[:about])
    @data = { name: @course.name.to_s, course_id: @course.id, creator_user_name: @user_auth.user_name,
              image: @course.image.url, about: @course.about }
    render status: :created
  end

  def courses
    @limit, @offset, @page = pagination_params
    @courses = Course.all.limit(@limit).offset(@offset)
    @data = []
    @courses.each do |course|
      @instructor = UserAuth.find(course.user_auth_id)
      @instructor_image = inst_image
      @activities = course.activities
      @lessons = @activities.select(:name, :description).distinct.uniq
      @activities_data = []
      @lessons.each do |lesson|
        @links_count = Activity.where('name = ? and link is not null',  lesson.name).count
        @pds_count = Activity.where('name = ? and link is null', lesson.name).count
        @activities_data.push({pdfs_count: @pds_count, links_count: @links_count, description: lesson.description, name: lesson.name})
      end
      @info = {id: course.id, name: course.name, image: course.image.url,
                instructor_user_name: @instructor.user_name, instructor_image: @instructor_image, about: course.about, activities: @activities_data }
      @data.push(@info)
    end

    @total = Course.all.count
    @count = @courses.count
    render status: :ok
  end

  def course
    @course = Course.find(course_params[:id])
    @course_image = @course.image.url
    @instructor = UserAuth.find(@course.user_auth_id)
    @instructor_image = inst_image
    @instructor_user_name = @instructor.user_name
    render status: :ok
  end

  def activities
    @limit, @offset, @page = pagination_params
    @activities = Course.find(activities_params[:id]).activities.limit(@limit).offset(@offset)
    @data = Set.new
    @activities.each do |activity|
      @links = Activity.where('name = ? and link is not null',  activity.name).select('link').pluck('link')
      @pdfs = Activity.where('name = ? and link is null', activity.name).select('document', 'course_id')
      @pdfs_link = []
      @pdfs.each do |pdf|
        @pdfs_link.push(pdf.document.url)
      end 
      @info = { activity_name: activity.name, activity_description: activity.description,
                instructor_user_name: activity.course.user_auth.user_name, links: @links, pdfs: @pdfs_link }
      # @info[:pdf] = (activity.document.url) if activity.link.nil?
      # @info[:link] = activity.link if activity.link
      @data << @info
    end
    @total = Course.find(activities_params[:id]).activities.count
    @count = @data.count
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
            Activity.create!(document: file, course: @course, name: permited_params[:name], description: permited_params[:description])
          end
        end
      end
      if permited_params[:link]
        ActiveRecord::Base.transaction do
          permited_params[:link].each do |youtube_link|
            Activity.create!(course: @course, name: permited_params[:name], link: youtube_link, description: permited_params[:description])
          end
        end
      end
      render status: :created
    end
  end

  def enroll
    permited_params = enroll_params
    @course = Course.find(permited_params[:course_id])
    Enrollment.create!(user_auth: @user_auth, course: @course)
    render json: {
      'status': 'success',
      "data": [
        {
          "message": 'Ernolled successfully!'
        }
      ]
    }, status: :ok
  end

  private

  def activity_params
    params.permit(:course_id, :name, :description, link: [], document_data: [])
  end

  def enroll_params
    params.permit(:course_id)
  end

  def create_course_params
    params.permit(:name, :image, :about)
  end

  def course_params
    params.permit(:id)
  end

  def activities_params
    params.permit(:id, :offset, :limit, :page)
  end
  def inst_image
    @instructor_image = if @instructor.role == 'admin'
                          @instructor.admin.image.url
                        else
                          @instructor.instructor.image.url
                        end
  end
end
