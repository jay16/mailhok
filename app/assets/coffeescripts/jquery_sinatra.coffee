#encoding: utf-8
window.Sinatra=
  deleteWithAjax: (remote_url, delete_dom) ->
    console.log(remote_url)
    console.log(delete_dom)
    $.ajax(
      type: "delete"
      url: remote_url
      success: (data) ->
        $(delete_dom).remove()
      error: ->
        alert("error:delete with ajax!")
    )
