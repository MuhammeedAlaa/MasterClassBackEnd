class AddUserAuthIdToLeaners < ActiveRecord::Migration[6.1]
  def change
     add_column :leaners, :user_auth_id, :integer
  end
end
