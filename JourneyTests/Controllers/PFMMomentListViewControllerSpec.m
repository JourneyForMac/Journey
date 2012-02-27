#import "TestHelper.h"
#import "PFMMomentListViewController.h"
#import "PFMMoment.h"
#import "PFMPhoto.h"
#import "SBJson.h"

SpecBegin(PFMMomentListViewController)

__block PFMMomentListViewController *controller;
__block PFMUser *user;
__block id mockUser;

before(^{
  [ASIHTTPRequest resetRequests];
  user = [NSApp resetSharedUser];
  mockUser = [OCMockObject partialMockForObject:user];
  controller = [PFMMomentListViewController new];
  [WebView resetJavascripts];
});

void (^openView)(void) = ^{
  [controller view];
};

it(@"loads MomentListView nib", ^{
  openView();
  expect([controller nibName]).toEqual(@"MomentListView");
});

it(@"sets itself to be shared user's sign in delegate", ^{
  openView();
  expect(user.momentsDelegate).toEqual(controller);
});

it(@"begins fetching moments", ^{
  [[mockUser expect] fetchMomentsNewerThan:0.0];
  openView();
  [mockUser verify];
});

it(@"is its webview's UIDelegate", ^{
  openView();
  expect([controller.webView UIDelegate]).toEqual(controller);
});

describe(@"-makeTemplateJSON:", ^{
  __block NSArray *moments;

  before(^{
    moments = $arr([PFMMoment momentFrom:$dict(@"1", @"id")],
                   [PFMMoment momentFrom:$dict(@"2", @"id")]);
    user.profilePhoto = [PFMPhoto new];
    user.profilePhoto.iOSHighResFileName = @"foo.jpg";
    user.coverPhoto = [PFMPhoto new];
    user.coverPhoto.iOSHighResFileName = @"bar.jpg";
  });

  it(@"prepares a json object needed by the view", ^{
    NSString *json = [controller makeTemplateJSON:moments];
    NSDictionary *dict = [json JSONValue];
    expect([dict objectForKey:@"moments"]).toEqual([moments $map:^(id moment) {
      return [(PFMMoment *)moment toHash];
    }]);
    expect([dict objectForKey:@"coverPhoto"]).toEqual([user.coverPhoto iOSHighResURL]);
    expect([dict objectForKey:@"profilePhoto"]).toEqual([user.profilePhoto iOSHighResURL]);
  });
});

describe(@"PFMUserMomentsDelegate", ^{
  before(^{
    openView();
  });

  describe(@"-didFetchMoments:atTop:", ^{
    context(@"when the moments given is an empty array", ^{
      before(^{
        [controller didFetchMoments:[NSArray array] atTop:YES];
      });

      it(@"calls Path.didCompleteRefresh() to stop the refresh animation", ^{
        expect([WebView javascripts]).toContain(@"Path.didCompleteRefresh()");
      });
    });

    context(@"when the moments given is not empty", ^{
      __block NSArray *moments;

      before(^{
        moments = $arr([PFMMoment momentFrom:$dict(@"1", @"id")],
                       [PFMMoment momentFrom:$dict(@"2", @"id")]);
      });

      context(@"when atTop is YES", ^{
        it(@"calls Path.renderTemplate js function with 'feed', <the template json>, true as arguments", ^{
          [controller didFetchMoments:moments atTop:YES];
          NSString *lastJSCall = [[WebView javascripts] lastObject];
          NSString *regex = $str(@"Path\\.renderTemplate\\(\\s*['\"]feed['\"]\\s*,\\s*.*\\s*,\\s*true\\s*\\)");
          expect(lastJSCall).toMatch(regex);
          expect(lastJSCall).toContain([controller makeTemplateJSON:moments]);
        });
      });

      context(@"when atTop is NO", ^{
        it(@"calls Path.renderTemplate js function with 'feed', <the template json>, false as arguments", ^{
          [controller didFetchMoments:moments atTop:NO];
          NSString *lastJSCall = [[WebView javascripts] lastObject];
          NSString *regex = $str(@"Path\\.renderTemplate\\(\\s*['\"]feed['\"]\\s*,\\s*.*\\s*,\\s*false\\s*\\)");
          expect(lastJSCall).toMatch(regex);
          expect(lastJSCall).toContain([controller makeTemplateJSON:moments]);
        });
      });
    });
  });

  describe(@"-didFailToFetchMoments", ^{
    it(@"calls Path.didCompleteRefresh javascript function", ^{
      [controller didFailToFetchMoments];
      expect([WebView javascripts]).toContain(@"Path.didCompleteRefresh()");
    });
  });
});

describe(@"-refreshFeed", ^{
  before(^{
    openView();
    [user parseMomentsJSON:loadStringFixture(@"moments_feed.json") insertAtTop:YES];
  });

  it(@"fetches moments newer than the first moment's createdAt", ^{
    double firstMomentCreatedAt = ((PFMMoment *)[user.fetchedMoments objectAtIndex:0]).createdAt;
    [[mockUser expect] fetchMomentsNewerThan:firstMomentCreatedAt];
    [controller refreshFeed];
    [mockUser verify];
  });
});

SpecEnd
