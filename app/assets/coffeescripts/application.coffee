#encoding: utf-8
window.App =
  showLoading: ->
    $(".loading").removeClass("hidden")

  showLoading: (text) ->
    $(".loading").html(text)
    $(".loading").removeClass("hidden")

  hideLoading:->
    $(".loading").addClass("hidden")
    $(".loading").html("loading...")

  # checkbox operation
  checkboxState: (self) ->
    state = $(self).attr("checked")
    if(state == undefined || state == "undefined")
      return false
    else
      return true

  checkboxChecked: (self) ->
      $(self).attr("checked", "true")

  checkboxUnChecked: (self) ->
      $(self).removeAttr("checked")

  checkboxState1: (self) ->
    state = $(self).attr("checked")
    if(state == undefined || state == "undefined")
      $(self).attr("checked", "true")
      return true
    else
      $(self).removeAttr("checked")
      return false

  reloadWindow: ->
    window.location.reload()

  cpanelNavbarInit: ->
    pathname = window.location.pathname
    klass = "." + pathname.split("/").join("-")
    console.log(klass)
    $(klass).siblings("li").removeClass("active")
    $(klass).addClass("active")

  resizeWindow: ->
    w = window
    d = document
    e = d.documentElement
    g = d.getElementsByTagName("body")[0]
    x = w.innerWidth or e.clientWidth or g.clientWidth
    y = w.innerHeight or e.clientHeight #|| g.clientHeight;

    nav_height    = 80 || $("nav:first").height()
    footer_height = 100 || $("footer:first").height()
    main_height   = y - nav_height - footer_height
    if main_height > 300
      $("#main").css
        height: main_height + "px"

# NProgress
NProgress.configure
  speed: 500

$ ->
  NProgress.start()

  App.resizeWindow()

  $("body").tooltip
    selector: "[data-toggle=tooltip]"
    container: "body"

  NProgress.set(0.2)

  $("body").popover
    selector: "[data-toggle=popover]"
    container: "body"

  NProgress.set(0.4)
  
  # navbar-nav active menu
  pathname = window.location.pathname
  $(".navbar-nav:first li").each ->
    href = $(this).children("a:first").attr("href")
    if pathname is href
      $(this).addClass "active"
    else
      $(this).removeClass "active"

  NProgress.set(0.8)

  NProgress.done(true)
