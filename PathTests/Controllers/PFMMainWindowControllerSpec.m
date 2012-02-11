#import "TestHelper.h"
#import "PFMMainWindowController.h"

SpecBegin(PFMMainWindowController)

__block PFMMainWindowController *controller;
__block PFMUser *user;

before(^{
  user = [NSApp sharedUser];
  user.email = nil;
  user.password = nil;
  user.signingIn = NO;
  controller = [PFMMainWindowController new];
  [[controller window] makeKeyAndOrderFront:nil];
});

after(^{
  [[controller window] close];
});

it(@"loads SignInWindow nib", ^{
  expect([controller windowNibName]).toEqual(@"MainWindow");
});

SpecEnd
