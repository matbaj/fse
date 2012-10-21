class CartItem < ActiveRecord::Base
  attr_accessible :cart_id, :count, :thing_id

  belongs_to :cart
  
  belongs_to :thing
end
