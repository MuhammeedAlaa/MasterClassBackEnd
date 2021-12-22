class AddImageToLearner < ActiveRecord::Migration[6.1]
  def change
    add_column :learners, :image, :string
  end
end
