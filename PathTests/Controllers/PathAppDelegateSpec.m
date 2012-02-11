#import "TestHelper.h"
#import "PathAppDelegate.h"
#import "PFMSignInWindowController.h"

SpecBegin(PathAppDelegate)

__block PathAppDelegate *appDelegate;

before(^{
  resetUserDefaultsAndKeychain();
  appDelegate = [NSApp delegate];
});

context(@"at launch", ^{
  __block id windowController;

  before(^{
    [appDelegate applicationDidFinishLaunching:nil];
    windowController = [[[NSApp orderedWindows] objectAtIndex:0] windowController];
  });

  it(@"initializes and shows signInWindowController", ^{
    expect(windowController).toBeKindOf([PFMSignInWindowController class]);
    expect([[windowController window] isVisible]).toEqual(YES);
  });

  after(^{
    [[windowController window] close];
  });
});

SpecEnd
