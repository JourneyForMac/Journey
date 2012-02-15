#import "TestHelper.h"
#import "PFMMomentListViewController.h"
#import "PFMMoment.h"

SpecBegin(PFMMomentListViewController)

__block PFMMomentListViewController *controller;
__block PFMUser *user;
__block id mockUser;

before(^{
  [ASIHTTPRequest resetRequests];
  user = [NSApp resetSharedUser];
  mockUser = [OCMockObject partialMockForObject:user];
  controller = [PFMMomentListViewController new];
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

describe(@"PFMUserMomentsDelegate", ^{
  before(^{
    openView();
  });

  describe(@"-didFetchMoments:", ^{
    before(^{

    });
  });
});

describe(@"-refreshFeed", ^{
  before(^{
    openView();
    [user parseMomentsJSON:loadStringFixture(@"moments_feed.json")];
  });

  it(@"fetches moments newer than the first moment's createdAt", ^{
    double firstMomentCreatedAt = ((PFMMoment *)[user.fetchedMoments objectAtIndex:0]).createdAt;
    [[mockUser expect] fetchMomentsNewerThan:firstMomentCreatedAt];
    [controller refreshFeed];
    [mockUser verify];
  });
});

SpecEnd
