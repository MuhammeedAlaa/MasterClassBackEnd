class AddBirthDayToAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :birthday, :datetime
  end
end
