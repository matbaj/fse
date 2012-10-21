class OrderItem < ActiveRecord::Base
  attr_accessible :cost, :count, :order_id, :thing

  belongs_to :order

end
