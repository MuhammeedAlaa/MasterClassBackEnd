class Comment < ApplicationRecord
  belongs_to :user_auth
  belongs_to :course
  belongs_to :parent, optional: true, class_name: "Comment"

  def comments
    Comment.where(course: course, parent_id: id)
  end
end