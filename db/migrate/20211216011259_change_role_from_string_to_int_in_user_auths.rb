class ChangeRoleFromStringToIntInUserAuths < ActiveRecord::Migration[6.1]
  def change
    change_column :user_auths, :role, :integer
  end
end
