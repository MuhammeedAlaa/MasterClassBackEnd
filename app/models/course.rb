
class Course < ApplicationRecord
  belongs_to :user_auth, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy
  mount_uploader :image, ImagesUploader

  after_find do
    self.image = Rails.root.join('public/images/fallback/courses/default.png').open if self.image.file.extension == ''
  end
  def threads
    Comment.where(course: self, parent_id: nil)
  end
end
