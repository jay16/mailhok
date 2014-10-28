(function() {
  window.Sinatra = {
    selfAjax: function(type, url, dom) {
      return $.ajax({
        type: type,
        url: url,
        success: function(data) {
          return $(dom).remove();
        },
        error: function() {
          return alert("error:delete with ajax!");
        }
      });
    },
    deleteWithAjax: function(url, dom, alert) {
      if (confirm(alert, "确定删除") === true) {
        return Sinatra.selfAjax("delete", url, dom);
      }
    }
  };

}).call(this);
