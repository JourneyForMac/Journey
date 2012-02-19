(function() {
  var self = window.Path = {
    templates: {
      feed: $('#feed_template').text()
    , moment: $('#moment_template').text()
    }

  , refreshing: false

  , init: function() {
      Path.initialized = true;
      Path.killScroll = false;
      Path.loadOldMomentsComplete = false;

      Path.handleWindowScroll();
      window.setInterval(self.didClickRefreshButton, 30000);
      $(window).resize(function(){ Path.setPathJourneyHeight(); });
      $(img).bind('load', function() { Path.setPathJourneyHeight(); });
    }

  , renderTemplate: function(name, object, atTop) {
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
        if(atTop) {
          $content.find('.moments').prepend($newMomentHTML);
        } else {
          $content.find('.moments').append($newMomentHTML);
          Path.killScroll = false;
        }
      }
      self.setPathJourneyHeight();
      self.didCompleteRefresh();
    }

  , setPathJourneyHeight: function() {
    $('#path_journey').css({'height':(($(document).height())-160-60)+'px'});
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
      document.location.replace('#complete_refresh');
      self.refreshing = false;
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

  , handleWindowScroll: function() {
      $(window).scroll(function() {
        if($(window).scrollTop() + 200 >= ($(document).height() - $(window).height())) {
          if(Path.killScroll === false && Path.loadOldMomentsComplete === false) {
            Path.killScroll = true;
            document.location.replace('#load_old_moments');
          }
        }
      });
    },
  };
}());

