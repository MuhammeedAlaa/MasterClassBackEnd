class AddUserAuthToCourse < ActiveRecord::Migration[6.1]
  def change
    add_reference :courses, :user_auth, null: false, foreign_key: true
  end
end
