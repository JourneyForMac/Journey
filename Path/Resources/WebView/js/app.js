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
      $('.friend.dot').cycle({fx: 'fade'});
    }

  , renderTemplate: function(name, object, atTop) {
      var $content = $('#content');
      if($content.children('.moments').length == 0) {
        $content.html(_.template(self.templates[name], object));
        $('abbr.timeago').timeago();
        $('.friend.dot').cycle({fx: 'fade'});
        $('#refresh_button').click(self.didClickRefreshButton);
      } else {
        // just prepend moments
        var $newMomentHTML = $(_.map(object.moments, function(m) {
          return _.template(self.templates.moment, {m: m});
        }).join(''));
        $newMomentHTML.find('abbr.timeago').timeago();
        $newMomentHTML.find('.friend.dot').cycle({fx: 'fade'});
        if(atTop) {
          $content.find('.moments').prepend($newMomentHTML);
        } else {
          Path.removeLoadingMessage();
          $content.find('.moments').append($newMomentHTML);
          Path.killScroll = false;
        }
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
            Path.showLoadingMessage();
            document.location.replace('#load_old_moments');
          }
        }
      });
    }

  , showLoadingMessage: function() {
      $('ul.moments').append('<li class="moment fetching"></li>');
    }

  , removeLoadingMessage: function() {
      $('.moments .fetching').remove();
    }

  };
}());

