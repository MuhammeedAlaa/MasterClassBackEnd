class Enrollment < ApplicationRecord
   belongs_to :user_auth 
   belongs_to :course  
end
