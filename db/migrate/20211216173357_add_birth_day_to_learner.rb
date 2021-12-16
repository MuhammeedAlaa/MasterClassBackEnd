class AddBirthDayToLearner < ActiveRecord::Migration[6.1]
  def change
    add_column :learners, :birthday, :datetime
  end
end
