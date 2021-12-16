class AddUserAuthsToLearner < ActiveRecord::Migration[6.1]
  def change
    add_column :learners, :user_auth_id, :integer
  end
end
