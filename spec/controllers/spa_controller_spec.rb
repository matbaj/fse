require 'spec_helper'

describe SpaController do
  it "should return frontend" do
  	get :index
  	response.should render_template("index")

  end
  it "should return things array" do
  	  @things = Thing.all
  	  get :things
      response.body == @things.to_json()
    
  end
  it "should return categories array" do
  	  @categories = Category.all
  	  get :categories
      response.body == @categories.to_json()
    
  end

  it "should send order" do
  	  @categories = Category.all
  	  post :categories, {"t"=>{"0"=>["280", "1"], "1"=>["280", "1"]}, "first"=>"First_name", "last"=>"Last_name"}
      response.body == "OK"
    
  end
end