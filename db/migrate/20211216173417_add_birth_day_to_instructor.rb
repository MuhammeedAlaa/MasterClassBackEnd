class AddBirthDayToInstructor < ActiveRecord::Migration[6.1]
  def change
    add_column :Instructors, :birthday, :datetime
  end
end
