class AddProfileFieldsToUserAuths < ActiveRecord::Migration[6.1]
  def change
    add_column :user_auths, :user_name, :string
    add_index :user_auths, :user_name, unique: true
  end
end
