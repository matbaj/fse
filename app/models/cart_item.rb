class CartItem < ActiveRecord::Base
  attr_accessible :cart_id, :count, :thing_id
end
