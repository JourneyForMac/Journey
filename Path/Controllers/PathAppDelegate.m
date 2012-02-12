#import "PathAppDelegate.h"
#import "PFMSignInWindowController.h"

@implementation PathAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  PFMSignInWindowController *signInWindowController = [PFMSignInWindowController new];
  NSWindow *window = [signInWindowController window];
  [window orderFrontRegardless];
  [window makeMainWindow];
  [window makeKeyWindow];
}

@end
