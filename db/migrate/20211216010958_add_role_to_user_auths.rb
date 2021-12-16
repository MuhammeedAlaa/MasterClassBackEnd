class AddRoleToUserAuths < ActiveRecord::Migration[6.1]
  def change
    add_column :user_auths, :role, :string
  end
end
