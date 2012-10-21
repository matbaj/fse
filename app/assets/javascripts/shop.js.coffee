# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


cart_hidden= 1
cart_new_hidden= 1
@cart_show  = () ->
	if cart_hidden
		$('#cart').animate({marginLeft: '-240px'},500, () -> cart_hidden=0)


@cart_hide = () ->
	if !cart_hidden
		$('#cart').animate({marginLeft: '0px'},500, () -> cart_hidden=1)

@cart_new_show  = () ->
	if cart_new_hidden
		$('#cart_new_object').effect("highlight",{},1000, () -> cart_new_hidden=0)


@cart_new_hide = () ->
	if !cart_new_hidden
		$('#cart_new_object').hide( )
		cart_new_hidden=1



# To jest funkcja toggle i ma powtórzoną funkcje sprawdzajaca, żeby ominąć bugi 
# Omija bugi ale strzela w stope optymalizacji
@cart_click = () ->
	if cart_hidden
		cart_show()
	else
		cart_hide()

$(document).ready ->
	$('.offer_box').draggable({
	    helper: "clone",
	    revert: "invalid",
		start: () -> 
	                cart_show()
	                cart_new_show()
	                $(this).css("z-index", 10) 

	    ,
	    stop: () -> 
	                cart_new_hide()

	    })
	$("#cart_new_object").droppable({
		drop: (event, ui) ->
			alert(ui.draggable.text())
	})