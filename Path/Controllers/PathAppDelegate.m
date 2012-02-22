#import "PathAppDelegate.h"
#import "PFMSignInWindowController.h"
#import "Application.h"

@implementation PathAppDelegate

@synthesize
  signInWindowController=_signInWindowController
, mainWindowController=_mainWindowController
;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  self.signInWindowController = [PFMSignInWindowController new];
  NSWindow *window = [self.signInWindowController window];
  [window orderFrontRegardless];
  [window makeMainWindow];
  [window makeKeyWindow];
}

- (IBAction)signOut:(id)sender {
  [self.mainWindowController close];
  self.mainWindowController = nil;
  [[NSApp sharedUser] deleteCredentials];
  NSWindow *window = [self.signInWindowController window];
  [window orderFrontRegardless];
  [window makeMainWindow];
  [window makeKeyWindow];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag {
  if (![NSApp keyWindow]) {
    if (self.mainWindowController) {
      [self.mainWindowController showWindow:self];
    } else if (self.signInWindowController) {
      [self.signInWindowController showWindow:self];
    }
  }

  return YES;
}

@end
