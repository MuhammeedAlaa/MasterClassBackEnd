class AddNameToActivity < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :name, :string
  end
end
