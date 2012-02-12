#import "TestHelper.h"
#import "PFMMomentListViewController.h"

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
  [[mockUser expect] fetchMoments];
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

SpecEnd
