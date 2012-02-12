(function() {
  window.Path = {
    templates: {
      moments: $('#moments_template').text()
    }

  , init: function() {
      Path.initialized = true;
    }

  , renderTemplate: function(name, json) {
      var obj = {};
      obj[name] = JSON.parse(json);
      $('#content').html(_.template(this.templates[name], obj));
    }
  };
}());

