$(document).ready =>
  height = $(window).height()
  element = $("#title")
  element.height(height - $(".container").height())
