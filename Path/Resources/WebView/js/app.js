(function() {
  var self = window.Path = {
    templates: {
      feed: $('#feed_template').text()
    , moment: $('#moment_template').text()
    }

  , refreshing: false

  , init: function() {
      Path.initialized = true;
      window.setInterval(self.didClickRefreshButton, 30000);
    }

  , renderTemplate: function(name, object) {
      var $content = $('#content');
      if($content.children().length == 0) {
        $content.html(_.template(self.templates[name], object));
        $('abbr.timeago').timeago();
        $('#refresh_button').click(self.didClickRefreshButton);
      } else {
        // just prepend moments
        var $newMomentHTML = $(_.map(object.moments, function(m) {
          return _.template(self.templates.moment, {m: m});
        }).join(''));
        $newMomentHTML.find('abbr.timeago').timeago();
        $content.find('.moments').prepend($newMomentHTML);
      }
      self.didCompleteRefresh();
    }

  , didClickRefreshButton: function() {
      if(!self.refreshing) {
        document.location.replace('#refresh_feed');
        self.refreshing = true;
        self.animateRefreshButton(true);
      }
      return false;
    }

  , didCompleteRefresh: function() {
      self.refreshing = false;
      document.location.replace('#');
      self.animateRefreshButton(false);
    }

  , animateRefreshButton: function(animate) {
      var $imgs = $('#refresh_button img');
      if(animate) {
        $imgs.addClass('loading');
      } else {
        $imgs.removeClass('loading');
      }
    }
  };
}());

