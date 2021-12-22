class AddImageToAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :image, :string
  end
end
