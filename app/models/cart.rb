class Cart < ActiveRecord::Base
  attr_accessible :buyer_id

  belongs_to :buyer
  
  has_many :cart_items
end
