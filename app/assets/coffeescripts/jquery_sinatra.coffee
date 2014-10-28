#encoding: utf-8
window.Sinatra=
  selfAjax: (type, url, dom) ->
    $.ajax(
      type: type 
      url: url
      success: (data) ->
        $(dom).remove()
      error: ->
        alert("error:delete with ajax!")
    )
  deleteWithAjax: (url, dom, alert) ->
    if confirm(alert, "确定删除") is true
      Sinatra.selfAjax("delete", url, dom)

