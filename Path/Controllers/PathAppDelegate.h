#import <Cocoa/Cocoa.h>

@class
  PFMSignInWindowController
, PFMMainWindowController
;

@interface PathAppDelegate : NSObject <
  NSApplicationDelegate
>

@property (nonatomic, retain) PFMSignInWindowController *signInWindowController;
@property (nonatomic, retain) PFMMainWindowController   *mainWindowController;

- (IBAction)signOut:(id)sender;

@end
