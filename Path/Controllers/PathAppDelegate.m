#import "PathAppDelegate.h"
#import "PFMSignInWindowController.h"
#import "PFMMainWindowController.h"
#import "PFMMomentListViewController.h"
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
  [window focus];
}

- (IBAction)signOut:(id)sender {
  [self.mainWindowController close];
  self.mainWindowController = nil;
  [[NSApp sharedUser] deleteCredentials];
  [[self.signInWindowController window] focus];
}

- (IBAction)showMainWindow:(id)sender {
  [[self.mainWindowController window] focus];
  NSScrollView *scrollView = [[[[self.mainWindowController.momentListViewController.webView mainFrame] frameView] documentView] enclosingScrollView];
  [[scrollView documentView] scrollPoint:NSMakePoint(0, 0)];
}

- (IBAction)quitApp:(id)sender {
  [(NSApplication *)NSApp terminate:nil];
}

-(void)awakeFromNib{
  NSStatusItem *statusItem = self.statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
  [statusItem setMenu:self.statusMenu];
  [statusItem setHighlightMode:YES];
  [statusItem setAlternateImage:[NSImage imageNamed:@"StatusItemIconSelected.png"]];
  [self highlightStatusItem:NO];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
  if (![NSApp keyWindow]) {
    if (self.mainWindowController) {
      [self.mainWindowController showWindow:self];
    } else if (self.signInWindowController) {
      [self.signInWindowController showWindow:self];
    }
  }
  return YES;
}

- (void)highlightStatusItem:(BOOL)highlighted {
  if(highlighted) {
    [self.statusItem setImage:[NSImage imageNamed:@"StatusItemIconHighlighted.png"]];
  } else {
    [self.statusItem setImage:[NSImage imageNamed:@"StatusItemIcon.png"]];
  }
}

@end
