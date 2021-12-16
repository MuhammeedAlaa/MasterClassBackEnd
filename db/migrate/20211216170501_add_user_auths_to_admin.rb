class AddUserAuthsToAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :user_auth_id, :integer
  end
end
