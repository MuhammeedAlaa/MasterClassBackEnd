class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user_auth, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer :parent_id
      t.text :body

      t.timestamps
    end
  end
end
