class DropTableLeaner < ActiveRecord::Migration[6.1]
  def change
    drop_table :leaners
  end
end
