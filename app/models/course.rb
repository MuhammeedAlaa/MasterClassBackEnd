
class Course < ApplicationRecord
  belongs_to :user_auth, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :activities
end
