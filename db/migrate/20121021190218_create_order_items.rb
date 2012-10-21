class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.string :thing
      t.integer :cost
      t.integer :count

      t.timestamps
    end
  end
end
