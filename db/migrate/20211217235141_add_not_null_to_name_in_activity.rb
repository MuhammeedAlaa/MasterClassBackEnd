class AddNotNullToNameInActivity < ActiveRecord::Migration[6.1]
  def change
    change_column :activities, :name, :string ,:null => false
  end
end
