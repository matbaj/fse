# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
	imie =prompt("Jak masz na imie?:")
	source   = $("#some-template").html();
	template = Handlebars.compile(source);
	data =  {imie : imie}
	$("#out").html(template(data));

