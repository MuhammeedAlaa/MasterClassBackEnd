# frozen_string_literal: true

# class for comments
class Api::V1::CommentsController < ApplicationController
  
  wrap_parameters false
  before_action :authenticate_any

  def create 
    permited_params = comment_params
    @course = Course.find(permited_params[:course_id])
    permited_params.delete('course_id')
    @comment = @course.comments.new(comment_params)
    @comment.user_auth = @user_auth
    @data = {comment_id: @comment.id, course_id: @course.id, user_id: @user_auth.id, parent_id: @comment.parent_id, body: @comment.body}
    if @comment.save
      render status: :created
    else
      render 'api/v1/errors/something_went_wrong', status: :Internal_server_error
    end
  end

  def threads
    permited_params = thread_params
    @course = Course.find(permited_params[:course_id])
    @threads = @course.threads
    render status: :ok
  end

  def thread_comments
    permited_params = thread_params
    @thread = Comment.find(permited_params[:thread_id])
    @threads_comment = @thread.comments
    render status: :ok
  end


  private

  def comment_params
      params.require(:comment).permit(:body, :parent_id, :course_id)
  end
  def thread_params
      params.permit(:course_id)
  end
  def thread_comments
      params.permit(:thread_id)
  end
end
