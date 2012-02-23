#import "TestHelper.h"
#import "PFMToolbarViewController.h"
#import "PFMUser.h"

SpecBegin(PFMToolbarViewController)

__block PFMToolbarViewController *controller;
__block PFMUser *user;
__block id mockUser;

before(^{
  [ASIHTTPRequest resetRequests];
  user = [NSApp resetSharedUser];
  mockUser = [OCMockObject partialMockForObject:user];
  controller = [PFMToolbarViewController new];
});

void (^openView)(void) = ^{
  [controller view];
};

it(@"loads ToolbarView nib", ^{
  openView();
  expect([controller nibName]).toEqual(@"ToolbarView");
});

SpecEnd
