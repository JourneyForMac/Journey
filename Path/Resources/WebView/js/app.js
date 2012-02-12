(function() {
  window.Path = {
    templates: {
      moments: $('#moments_template').text()
    }

  , init: function() {
      Path.initialized = true;
    }

  , renderTemplate: function(name, object) {
      var obj = {};
      obj[name] = object;
      $('#content').html(_.template(this.templates[name], obj));
      $('abbr.timeago').timeago();
    }
  };
}());

