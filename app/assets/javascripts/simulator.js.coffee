#= require jquery
#= require jquery_ujs

window.Simulator =
  hideSplashScreen: () ->
    $('#splash-screen').hide()
    $('#simulator-iframe').show()

$(document).ready ->
  setTimeout("Simulator.hideSplashScreen()", 3000);