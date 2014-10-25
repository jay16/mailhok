(function() {
  window.Sinatra = {
    deleteWithAjax: function(remote_url, delete_dom) {
      console.log(remote_url);
      console.log(delete_dom);
      return $.ajax({
        type: "delete",
        url: remote_url,
        success: function(data) {
          return $(delete_dom).remove();
        },
        error: function() {
          return alert("error:delete with ajax!");
        }
      });
    }
  };

}).call(this);
