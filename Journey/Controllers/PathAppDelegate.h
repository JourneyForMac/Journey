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
  NSMenu       *_mainMenu;
  NSMenu       *_statusMenu;
  NSStatusItem *_statusItem;
  NSObjectController *_sharedUserController;
}

@property (nonatomic, retain) PFMSignInWindowController *signInWindowController;
@property (nonatomic, retain) PFMMainWindowController   *mainWindowController;
@property (nonatomic, retain) IBOutlet NSMenu *mainMenu;
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) NSStatusItem    *statusItem;
@property (nonatomic, retain) IBOutlet NSObjectController *sharedUserController;

- (IBAction)signOut:(id)sender;
- (IBAction)showMainWindow:(id)sender;
- (IBAction)quitApp:(id)sender;
- (void)highlightStatusItem:(BOOL)highlighted;

@end
