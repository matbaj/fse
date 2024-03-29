# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


#$ ->
	#imie =prompt("Jak masz na imie?:")
	#imie ="asd"
	#source   = $("#some-template").html();
	#template = Handlebars.compile(source);
	#data =  {imie : imie}
	#$("#out").html(template(data));

#And this is the end of easy part ):

@cart_hidden= 1
@cart_new_hidden= 1
@page_detail_hidden = 0

class Backend
  send_order: (data,form_data) ->
    console.log("Sending data to backend")
    post_data = {t:data, first:form_data['first'], last:form_data['last']}
    console.log(post_data)
    $.post("/spa/send_order", post_data );





#local storage
class LocalStorage
  constructor: (@namespace) ->

  set: (key, value) =>
    # console.log(value) i had enough of this shit
    $.jStorage.set("#{@namespace}/#{key}", value)

  get: (key) =>
    $.jStorage.get("#{@namespace}/#{key}")

  fetchThings: =>


  getThings: =>
    @things = @get("things").map( (thingData) =>
        thing = new Thing(thingData.id, thingData.name, thingData.cost, thingData.about)
        return thing
    )


  newThing: (id,name,cost) =>
    thing = new Thing(id,name,cost)
    return thing

  getCart: =>
    if(!@get("cart"))
      return []
    $("#empty_cart").hide()
    @get("cart").map( (cartData) =>
        object = new CartObject(cartData.id,cartData.thing, cartData.quantity)
        return object
    )

  remove: (key) =>
    $.jStorage.deleteKey("#{@namespace}/#{key}")

  flush: =>
    for key in $.jStorage.index()
      if key.match("^#{@namespace}")
        $.jStorage.deleteKey(key)



#end local storage




#UTILS

_.defaults this,
  Before: (object, methodName, adviseMethod) ->
    YouAreDaBomb(object, methodName).before(adviseMethod)
  BeforeAnyCallback: (object, methodName, adviseMethod) ->
    YouAreDaBomb(object, methodName).beforeAnyCallback(adviseMethod)
  After: (object, methodName, adviseMethod) ->
    YouAreDaBomb(object, methodName).after(adviseMethod)
  Around: (object, methodName, adviseMethod) ->
    YouAreDaBomb(object, methodName).around(adviseMethod)

  AfterAll: (object, methodNames, adviseMethod) ->
    for methodName in methodNames
      After(object, methodName, adviseMethod)

  LogAll: (object) ->
    for own key, value of object
      if _.isFunction(value)
        do (key) ->
          Before(object, key, -> console.log("calling: #{key}"))

  AutoBind: (gui, useCase) ->
    for key, value of gui
      if _.isFunction(value)
        do (key) ->
          if key.endsWith("Clicked") and useCase[key.remove("Clicked")]
            After(gui, key, (args) -> useCase[key.remove("Clicked")](args))

#end utils


# AGRRR ... MY MIND IS FULL OF FUCK!
# http://24.media.tumblr.com/tumblr_m1mlx9XVHm1r8q8mpo1_400.gif

#USE CASE
class UseCase
  constructor: ->
    @things = []
    @cart = []

  setInitialThings: (things) =>
    @things = things

  setInitialCart: (cart) =>
    @cart = cart

  showAll: =>

  checkIfEmpty: () ->
    if @cart.length
      @notEmptyCart()
    else
      @EmptyCart()

  notEmptyCart: () ->

  EmptyCart: () ->

  remove_co: (id) =>
    for co in @cart
      if "#{co.id}" == "#{id}"
        @cart.remove(co)

  get_co: (id) =>
    for co in @cart
      if "#{co.id}" == "#{id}"
        return co    

  get_thing: (id) =>
    for thing in @things
      if "#{thing.id}" == "#{id}"
        return thing

  update_co: (id,quantity) =>
    for co in @cart
      if "#{co.id}" == "#{id}"
        co.quantity = parseInt(quantity)

  
  new_cart_object: (id) =>
    cart_object = new CartObject(UUIDjs.randomUI48(),@get_thing(id),1)
    @cart.push(cart_object)

  send_order: () =>
    things_array = []
    for c in @cart
      things_array.push([c.thing.id,c.quantity])
    things_array 



#Models
class Thing
  constructor: (@id, @name, @cost, @about) ->


class CartObject
  constructor: (@id, @thing, @quantity) ->

#END USE CASE

#WEB GUI
class WebGui
  constructor: ->
    $("#cart_end_button").click( => @finalizeOrder())
    $("#cart_new_object").droppable({
      drop: (event, ui) ->
        _this.cart_add_new(ui.draggable[0].id.split("_")[1])
    })
    $("#search").keyup( => @keyPressed())
    $("#q_about_true").change( => @keyPressed())
    $('#detail_page').click( => @page_detail_hide())
    $("#detail_page #frame").click((e) => e.stopPropagation())
    @thingsElements = []
    @cart_hidden= 1
    @cart_new_hidden= 1
    @page_detail_hidden = 0

  set_quantity_changable: (quantityChange) ->
    $(".quantity").unbind('change');
    $(".quantity").change(-> quantityChange(this.parentNode.parentNode.id.split("_")[1]))

  set_removable_co: (remove_co) ->
    $(".remove_button").unbind('click');
    $(".remove_button").click(-> remove_co(this.parentNode.id.split("_")[1]))

  set_dragable: () ->
    $(".offer_box").dblclick(-> _this.showDetail(this.id.split("_")[1]) )
    $(".detail_btn").click(-> _this.showDetail(this.parentNode.id.split("_")[1]) )
    $(".to_cart_btn").click(-> _this.cart_add_new(this.parentNode.id.split("_")[1]) )
    $('.offer_box').draggable(
      helper: "clone",
      revert: "invalid",
      start: () => 
        if cart_hidden
          $('#cart').animate({marginLeft: '-240px'},500, () -> cart_hidden=0)
        if cart_new_hidden
          $('#cart_new_object').effect("highlight",{},1000, () -> cart_new_hidden=0)
        $(this).css("z-index", 10) 
        
      stop: () => 
        if !cart_new_hidden
          $('#cart_new_object').hide()
          cart_new_hidden=1

    )

  cart_add_new: (id) =>

  counter_update: (cart) =>
    $("#cart_counter").html(cart.length)

  set_detail_content: (thing) =>
    source = $("#detail_tpl").html()
    template = Handlebars.compile(source)
    data = {id: thing.id, name: thing.name, cost: thing.cost, about: thing.about}
    html = template(data)
    $(".detail_content").html(html)
    $(".close_btn").click( => @page_detail_hide())

  get_form_data: () ->
    first = $("#order_first_name").val()
    last = $("#order_last_name").val()
    {first: first, last: last }
    
  finalizeOrder: () ->

  get_quantity: (id) ->
    $("#co_"+id+" .count .quantity").val()

  page_detail_hide: () =>
    if !@page_detail_hidden
      $('#detail_page').hide( )
      @page_detail_hidden=1

  page_detail_show: () =>
    if @page_detail_hidden
      $('#detail_page').show()
      @page_detail_hidden=0
      #$('#detail_page').effect("show",{},1000, () -> @page_detail_hidden=0)


  cart_hide = () =>
    if !@cart_hidden
      $('#cart').animate({marginLeft: '0px'},500, () -> @cart_hidden=1)

  cart_show  = () =>
    if @cart_hidden
      $('#cart').animate({marginLeft: '-240px'},500, () -> @cart_hidden=0)

  createElementFor: (thing, templateId) =>
    source = $(templateId).html()
    template = Handlebars.compile(source)
    data = {id: thing.id, name: thing.name, cost: thing.cost}
    html = template(data)
    element = $(html)

  addNewThing: (thing) =>
    element = @createElementFor(thing, "#offer_box_tpl")
    element.thing = thing
    @thingsElements.push(element)
    $("#product_list").append(element)

  hideEmptyCart: () ->
    $("#empty_cart").hide()

  showEmptyCart: () ->
    $("#empty_cart").show()

  addNewCartObject: (cart_object) =>
    source = $("#cart_object_tpl").html()
    template = Handlebars.compile(source)
    data = {thing: cart_object.thing,id: cart_object.id, quantity: cart_object.quantity, sum: cart_object.thing.cost*cart_object.quantity}
    $(template(data)).insertAfter('#cart_new_object');

  setfilter: (things) =>
    search = $("#search").val()
    for thing in things
      if (thing.name.has(search) || ($("#q_about_true").is(':checked')  && thing.about.has(search) ))
        @showThing(thing)
      else
        @hideThing(thing)
  
  hideThing: (thing) =>
    $("#offer_"+thing.id).addClass("offer_hidden");

  showThing: (thing) =>
    $("#offer_"+thing.id).removeClass("offer_hidden");

  showCart: (cart) =>
    for cart_object in cart
      @addNewCartObject(cart_object)

  showThings: (things) =>
    $("#product_list").html("")
    for thing in things
      @addNewThing(thing)

  sum_cart: (cart) =>
    sum = 0
    for co in cart
      sum += co.thing.cost*co.quantity
    $("#cart_sum").html(sum)
    $("#cart_summary").effect("highlight", {}, 1000);

  prepareOrderDetails: (cart) =>
    source = $("#order_object_tpl").html()
    order_list = ""
    sum = 0
    for co in cart
      template = Handlebars.compile(source)
      data = {thing: co.thing,id: co.id, quantity: co.quantity, sum: co.thing.cost*co.quantity}
      order_list += template(data)
      sum += co.thing.cost*co.quantity
    source = $("#order_finalize_tpl").html()
    template = Handlebars.compile(source)
    data = {order_list: order_list,sum: sum}
    $(".detail_content").html(template(data))
    $(".close_btn").click( => @page_detail_hide())
    $(".THE_LAST_FINALIZE_BUTTON").click( => @finalizePayment())


  quantityChange: (id) =>

  showDetail: (id) =>


  keyPressed: () =>

  remove_co: (id) =>
    $("#co_"+id).remove();

  cleancart: (cart) ->
    for i in [cart.length-1..0] by -1
      this.remove_co(cart[i].id)

  update_co: (id,cart_object) ->
    sum = cart_object.quantity * parseInt(cart_object.thing.cost)
    $("#co_"+id+" .price_sum").html("#{sum} PLN") #Very very very dirty but it's 5:39:50!


  #7:00 ... and the last method
  finalizePayment: () => # And it will be just an event :D
  
  preparefinishpage: () =>
    source = $("#done_page_tpl").html()
    template = Handlebars.compile(source)
    $(".detail_content").html(template())
    $(".close_btn").click( => @page_detail_hide())


#END WEBGUI

#WEB GLUE http://25.media.tumblr.com/tumblr_m1mk6ng8aC1r2r396o1_500.jpg
class WebGlue
  constructor: (@useCase, @gui, @storage, @backend)->
    AutoBind(@gui, @useCase)
    After(@gui, 'keyPressed',  => @gui.setfilter(@useCase.things))
    Before(@useCase, 'showAll',  => @useCase.setInitialThings(@storage.getThings()))
    Before(@useCase, 'showAll',  => @useCase.setInitialCart(@storage.getCart()))
    Before(@gui, 'cart_add_new', (id) =>  @useCase.new_cart_object(id))
    Before(@gui, 'showDetail', (id) => @gui.set_detail_content(@useCase.get_thing(id)))
    Before(@gui, 'quantityChange', (id) => @useCase.update_co(id,@gui.get_quantity(id)))
    Before(@gui, 'finalizeOrder', => @gui.prepareOrderDetails(@useCase.cart))
    Before(@gui, 'finalizePayment', => @backend.send_order(@useCase.send_order(),@gui.get_form_data()))
    
    After(@useCase, 'update_co', (id) =>  @gui.update_co(id,@useCase.get_co(id)))
    After(@gui, 'cart_add_new', (id) =>  @useCase.checkIfEmpty())
    After(@useCase, 'notEmptyCart', => @gui.hideEmptyCart())
    After(@useCase, 'EmptyCart', => @gui.showEmptyCart())
    After(@useCase, 'remove_co', => @useCase.checkIfEmpty())
    After(@useCase, 'new_cart_object', => @storage.set('cart', @useCase.cart))
    After(@useCase, 'new_cart_object', => @gui.counter_update(@useCase.cart))
    After(@useCase, 'new_cart_object', => @gui.addNewCartObject(@useCase.cart.last()))
    After(@useCase, 'showAll',  => @gui.showThings(@useCase.things))
    After(@useCase, 'showAll',  => @gui.showCart(@useCase.cart))
    After(@useCase, 'showAll', => @gui.counter_update(@useCase.cart))
    After(@useCase, 'showAll', => @gui.sum_cart(@useCase.cart))
    After(@useCase, 'new_cart_object', => @gui.sum_cart(@useCase.cart))
    After(@gui, 'addNewCartObject', =>  @gui.set_quantity_changable(@gui.quantityChange))
    After(@gui, 'addNewCartObject', =>  @gui.set_removable_co(@gui.remove_co))
    After(@gui, 'showThings',  => @gui.set_dragable())
    After(@gui, 'showThings',  => @gui.page_detail_hide())
    After(@gui, 'showDetail', (id) => @gui.page_detail_show())
    After(@useCase, 'update_co', => @storage.set('cart', @useCase.cart))
    After(@useCase, 'update_co', => @gui.sum_cart(@useCase.cart))
    After(@gui, 'remove_co', (id) => @useCase.remove_co(id))
    After(@useCase, 'remove_co', => @storage.set('cart', @useCase.cart))
    After(@useCase, 'remove_co', => @gui.counter_update(@useCase.cart))
    After(@useCase, 'remove_co', => @gui.sum_cart(@useCase.cart))
    After(@gui, 'finalizeOrder', => @gui.page_detail_show())
    After(@useCase, 'finalizePayment', => @gui.page_detail_hide())
    After(@backend, 'send_order', =>@gui.preparefinishpage())
    After(@backend, 'send_order', =>@gui.cleancart(@useCase.cart))
    After(@gui, 'preparefinishpage', =>@gui.page_detail_show())
    


    #LogAll(@useCase)
    #LogAll(@gui)

#END WEB GLUE

class SPA
  constructor: ->
    @useCase = new UseCase()
    window.useCase = UseCase
    @gui = new WebGui()
    @backend = new Backend()
    @localStorage = new LocalStorage("spa")
    glue = new WebGlue(@useCase, @gui, @localStorage, @backend)
    callback = (response) => 
      @localStorage.set("things", response)
      @useCase.showAll()
    $.get '/spa/things/', {}, callback, 'json'
    $("#alert").ajaxError( (event, request, settings) =>
      $(this).append("<li>Error requesting page " + settings.url + "</li>");
    );
    


$ ->
  @app = new SPA() # http://25.media.tumblr.com/tumblr_m1mky18yLL1qbl3n1o1_500.gif
 # dropable()

window.SPA= SPA
window.LocalStorage = LocalStorage
