#import "PathAppDelegate.h"
#import "PFMSignInWindowController.h"

@implementation PathAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  PFMSignInWindowController *signInWindowController = [PFMSignInWindowController new];
  [signInWindowController.window makeKeyAndOrderFront:nil];
}

@end
