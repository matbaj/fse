class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :name
      t.text :about
      t.integer :cost
      t.integer :category_id

      t.timestamps
    end
  end
end
