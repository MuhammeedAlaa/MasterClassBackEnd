class Instructor < ApplicationRecord
   belongs_to :user_auth, dependent: :destroy  
   mount_uploader :image, ImagesUploader
   after_find do
    if self.image.nil?
      self.image = Rails.root.join('public/images/fallback/users/default.png').open
    end
  end
end
