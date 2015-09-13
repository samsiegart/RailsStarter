$(document).on 'ready page:load', ->
  height = $(window).height()
  element = $("#title")
  element.height(height - $(".container").height())
