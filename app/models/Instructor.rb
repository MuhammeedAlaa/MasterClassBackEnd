class Instructor < ApplicationRecord
   belongs_to :user_auth, dependent: :destroy  
   mount_uploader :image, ImagesUploader
   after_find do
    self.image = Rails.root.join('public/images/fallback/users/default.png').open if self.image.file.extension == ''
  end
end
