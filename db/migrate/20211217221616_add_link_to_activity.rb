class AddLinkToActivity < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :link, :string
  end
end
