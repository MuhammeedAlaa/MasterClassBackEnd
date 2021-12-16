class AddUserAuthsToInstructor < ActiveRecord::Migration[6.1]
  def change
    add_column :instructors, :user_auth_id, :integer
  end
end
