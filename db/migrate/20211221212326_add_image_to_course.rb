class AddImageToCourse < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :image, :string
  end
end
