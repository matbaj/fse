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



#local storage
class LocalStorage
  constructor: (@namespace) ->

  set: (key, value) =>
    # console.log(value) i had enough of this shit
    $.jStorage.set("#{@namespace}/#{key}", value)

  get: (key) =>
    $.jStorage.get("#{@namespace}/#{key}")

  getThings: =>
    callback = (response) => 
      @set("things", response)
    $.get '/spa/things/', {}, callback, 'json'
    $("#alert").ajaxError( (event, request, settings) =>
      $(this).append("<li>Error requesting page " + settings.url + "</li>");
    );
    @get("things").map( (thingData) =>
        thing = new Thing(thingData.id, thingData.name, thingData.cost, thingData.about)
        return thing
    )


  newThing: (id,name,cost) =>
    thing = new Thing(id,name,cost)
    return thing


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

  setInitialThings: (things) =>
    @things = things


  showAll: =>

  get_thing: (id) =>
    for thing in @things
      if "#{thing.id}" == "#{id}"
        return thing




#Models
class Thing
  constructor: (@id, @name, @cost, @about) ->


#END USE CASE

#WEB GUI
class WebGui
  constructor: ->
    $("#cart_new_object").droppable({
      drop: (event, ui) ->
        cart_add_new(ui.draggable[0].id.split("_")[1])
    })
    $("#search").keyup( => @keyPressed())
    $('#detail_page').click( => @page_detail_hide())
    $("#detail_page #frame").click((e) => e.stopPropagation())
    @thingsElements = []
    @cart_hidden= 1
    @cart_new_hidden= 1
    @page_detail_hidden = 0

  set_dragable: () ->
    $(".offer_box").dblclick(-> _this.showDetail(this.id.split("_")[1]) )
    $(".detail_btn").click(-> _this.showDetail(this.parentNode.id.split("_")[1]) )
    $('.offer_box').draggable(
      helper: "clone",
      revert: "invalid",
      start: () => 
        cart_show()
        cart_new_show()
        $(this).css("z-index", 10) 
        
      stop: () => 
        cart_new_hide()

    )

  set_detail_content: (thing) =>
    source = $("#detail_tpl").html()
    template = Handlebars.compile(source)
    data = {id: thing.id, name: thing.name, cost: thing.cost, about: thing.about}
    html = template(data)
    $(".detail_content").html(html)
    $(".close_btn").click( => @page_detail_hide())

  showDetail: (id) =>
    



  page_detail_hide: () =>
    if !@page_detail_hidden
      $('#detail_page').hide( )
      @page_detail_hidden=1

  page_detail_show: () =>
    if @page_detail_hidden
      $('#detail_page').show()
      @page_detail_hidden=0
      #$('#detail_page').effect("show",{},1000, () -> @page_detail_hidden=0)

  cart_new_hide = () =>
    if !@cart_new_hidden
      $('#cart_new_object').hide( )
      @cart_new_hidden=1
  cart_new_show  = () =>
    if @cart_new_hidden
      $('#cart_new_object').effect("highlight",{},1000, () -> @cart_new_hidden=0)

  cart_hide = () =>
    if !@cart_hidden
      $('#cart').animate({marginLeft: '0px'},500, () -> @cart_hidden=1)

  cart_show  = () =>
    if @cart_hidden
      alert("pokazuje")
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


  setfilter: (things) =>
    search = $("#search").val()
    console.log(search)
    for thing in things
      if thing.name.has(search)
        @showThing(thing)
      else
        @hideThing(thing)
  
  hideThing: (thing) =>
    $("#offer_"+thing.id).addClass("offer_hidden");

  showThing: (thing) =>
    $("#offer_"+thing.id).removeClass("offer_hidden");



  showThings: (things) =>
    $("#product_list").html("")
    for thing in things
      @addNewThing(thing)


  keyPressed: () =>
  





#END WEBGUI

#WEB GLUE http://25.media.tumblr.com/tumblr_m1mk6ng8aC1r2r396o1_500.jpg
class WebGlue
  constructor: (@useCase, @gui, @storage)->
    AutoBind(@gui, @useCase)
    After(@gui, 'keyPressed',  => @gui.setfilter(@useCase.things))
    Before(@useCase, 'showAll',  => @useCase.setInitialThings(@storage.getThings()))
    After(@useCase, 'showAll',  => @gui.showThings(@useCase.things))
    After(@gui, 'showThings',  => @gui.set_dragable())
    After(@gui, 'showThings',  => @gui.page_detail_hide())
    Before(@gui, 'showDetail', (id) => @gui.set_detail_content(@useCase.get_thing(id)))
    After(@gui, 'showDetail', (id) => @gui.page_detail_show())
    #LogAll(@useCase)
    #LogAll(@gui)


#END WEB GLUE

class SPA
  constructor: ->
    useCase = new UseCase()
    window.useCase = useCase
    gui = new WebGui()
    localStorage = new LocalStorage("spa")
    glue = new WebGlue(useCase, gui, localStorage)
    useCase.showAll()


$ ->
  @app = new SPA() # http://25.media.tumblr.com/tumblr_m1mky18yLL1qbl3n1o1_500.gif
 # dropable()
