class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.integer :cart_id
      t.integer :thing_id
      t.integer :count

      t.timestamps
    end
  end
end
