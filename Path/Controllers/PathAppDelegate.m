#import "PathAppDelegate.h"
#import "PFMSignInWindowController.h"
#import "PFMMainWindowController.h"
#import "Application.h"

@implementation PathAppDelegate

@synthesize
  signInWindowController=_signInWindowController
, mainWindowController=_mainWindowController
, statusMenu=_statusMenu
, statusItem=_statusItem
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

- (IBAction)toggleWindowDisplay:(id)sender {
//  NSMenuItem * menuItem = (NSMenuItem *)sender;
  if (self.mainWindowController && [[self.mainWindowController window] isVisible] == YES) {
    [self.mainWindowController hideWindow];
  } else {
    [self.mainWindowController showWindow:self];
  }
}

- (IBAction)quitApp:(id)sender {
  [(NSApplication *)NSApp terminate:nil];
}

-(void)awakeFromNib{
  NSStatusItem *statusItem = self.statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
  [statusItem setMenu:self.statusMenu];
  [statusItem setHighlightMode:YES];
  [statusItem setImage:[NSImage imageNamed:@"StatusItemIcon.png"]];
  [statusItem setAlternateImage:[NSImage imageNamed:@"StatusItemIconSelected.png"]];
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
