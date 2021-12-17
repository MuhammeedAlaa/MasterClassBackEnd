class Course < ApplicationRecord
   belongs_to :user_auth, dependent: :destroy  
end
