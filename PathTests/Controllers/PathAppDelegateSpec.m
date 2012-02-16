#import "TestHelper.h"
#import "PathAppDelegate.h"
#import "PFMSignInWindowController.h"
#import "PFMMainWindowController.h"

SpecBegin(PathAppDelegate)

__block PathAppDelegate *appDelegate;
__block PFMUser *user;
__block id mockUser;

before(^{
  resetUserDefaultsAndKeychain();
  user = [NSApp resetSharedUser];
  mockUser = [OCMockObject partialMockForObject:user];
  appDelegate = [NSApp delegate];
});

context(@"at launch", ^{
  __block id windowController;

  before(^{
    [appDelegate applicationDidFinishLaunching:nil];
    windowController = [[[NSApp orderedWindows] objectAtIndex:0] windowController];
  });

  it(@"initializes and shows signInWindowController", ^{
    expect(appDelegate.signInWindowController).toBeIdenticalTo(windowController);
    expect(appDelegate.signInWindowController).toBeKindOf([PFMSignInWindowController class]);
    expect([[appDelegate.signInWindowController window] isVisible]).toEqual(YES);
  });

  after(^{
    [appDelegate.signInWindowController close];
  });
});

describe(@"-signOut:", ^{
  before(^{
    [appDelegate.signInWindowController close];
    appDelegate.mainWindowController = [PFMMainWindowController new];
    [[appDelegate.mainWindowController window] makeKeyAndOrderFront:nil];
  });

  void (^doAction)(void) = ^{
    [appDelegate signOut:nil];
  };

  it(@"invokes user's deleteCredentials method", ^{
    [[mockUser expect] deleteCredentials];
    doAction();
    [mockUser verify];
  });

  it(@"closes mainWindow and nullifies mainWindowController pointer", ^{
    id mockMainWindowController = [OCMockObject partialMockForObject:appDelegate.mainWindowController];
    [[mockMainWindowController expect] close];
    doAction();
    [mockMainWindowController verify];
    expect(appDelegate.mainWindowController).toBeNil();
  });

  it(@"shows sign in window controller", ^{
    doAction();
    id windowController = [[[NSApp orderedWindows] objectAtIndex:0] windowController];
    expect(appDelegate.signInWindowController).toBeIdenticalTo(windowController);
    expect([[appDelegate.signInWindowController window] isVisible]).toEqual(YES);
  });
});

SpecEnd
