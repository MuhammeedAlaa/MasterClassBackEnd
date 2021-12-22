# frozen_string_literal: true

class Admin < ApplicationRecord
  belongs_to :user_auth, dependent: :destroy
  mount_uploader :image, ImagesUploader

end
