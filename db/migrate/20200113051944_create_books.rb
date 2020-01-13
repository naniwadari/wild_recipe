class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.integer :user_id
      t.integer :recipe_id

      t.timestamps
    end
    add_index :books, :user_id
    add_index :books, :recipe_id
    add_index :books, [:user_id,:recipe_id], unique: true
  end
end
