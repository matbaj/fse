# use require to load any .js file available to the asset pipeline
#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require jquery.json-2.3.min
#= require jstorage.min
#= require sugar-1.3.min
#= require underscore
#= require YouAreDaBomb
#= require YouAreDaChef
#= require handlebars
#= require uuid
#= require spa


describe "Getting started", ->

  beforeEach ->
  	@app = new window.SPA()

  it "Has to be absolute truth! ... NO EXCEPTIONS!!!11!", ->
  	expect(true).toEqual(true);

  it "Has to start", ->
  	expect(@app).not.toBe(undefined)

  it "things list is not empty", ->
  	expect(@app.localStorage.getThings().length).not.toBe(0)

describe "Testing UseCase", ->
    beforeEach ->
      @app = new window.SPA()
      useCase.things = @app.localStorage.getThings()


#   it 'Should add new object to cart', ->
#     useCase.new_cart_object(177)
      


describe "Testing Live application (Testing Cart)", ->
  beforeEach ->
    @app = new window.SPA()

  it "There should be empty cart", ->
    expect(@app.useCase.cart.length).toBe(0)
