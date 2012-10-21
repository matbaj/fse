class Order < ActiveRecord::Base
  attr_accessible :buyer_id, :status

  belongs_to :buyer
  
  has_many :order_items
end
