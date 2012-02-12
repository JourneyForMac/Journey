(function() {
  window.Path = {
    templates: {
      moments: $('#moments_template').text()
    }

  , init: function() {
      Path.initialized = true;
    }

  , renderTemplate: function(name, object) {
      $('#content').html(_.template(this.templates[name], object));
      $('abbr.timeago').timeago();
    }
  };
}());

