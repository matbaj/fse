class Thing < ActiveRecord::Base
  attr_accessible :about, :category_id, :cost, :name
  belongs_to :category
end
