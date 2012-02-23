#import <Cocoa/Cocoa.h>

@class
  PFMSignInWindowController
, PFMMainWindowController
;

@interface PathAppDelegate : NSObject <
  NSApplicationDelegate
> {
  PFMSignInWindowController *_signInWindowController;
  PFMMainWindowController   *_mainWindowController;
  NSMenu       *_statusMenu;
  NSStatusItem *_statusItem;
}

@property (nonatomic, retain) PFMSignInWindowController *signInWindowController;
@property (nonatomic, retain) PFMMainWindowController   *mainWindowController;
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) NSStatusItem    *statusItem;

- (IBAction)signOut:(id)sender;
- (IBAction)showMainWindow:(id)sender;
- (IBAction)quitApp:(id)sender;
- (void)highlightStatusItem:(BOOL)highlighted;

@end
