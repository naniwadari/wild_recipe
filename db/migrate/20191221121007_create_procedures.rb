class CreateProcedures < ActiveRecord::Migration[5.1]
  def change
    create_table :procedures do |t|
      t.integer :number
      t.text :content
      t.references :recipe, foreign_key: true

      t.timestamps
    end
  end
end
