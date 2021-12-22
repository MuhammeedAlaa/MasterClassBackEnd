class AddDescriptionToActivity < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :description, :string
  end
end
