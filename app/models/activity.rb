class Activity < ApplicationRecord
  belongs_to :course
  mount_uploader :document, DocumentUploader
end
