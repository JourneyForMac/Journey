#import <Cocoa/Cocoa.h>
#import "PFMUser.h"

@interface PFMSignInWindowController : NSWindowController <
  PFMUserSignInDelegate
> {
  NSButton *_signInButton;
  NSTextField *_emailField;
  NSTextField *_passwordField;
  NSProgressIndicator *_spinner;
  NSTextField *_emailLabel;
  NSTextField *_passwordLabel;
  NSObjectController *_sharedUserController;
}

- (IBAction)didClickOnSignInButton:(id)sender;

@property (nonatomic, retain) IBOutlet NSButton *signInButton;
@property (nonatomic, retain) IBOutlet NSTextField *emailField;
@property (nonatomic, retain) IBOutlet NSTextField *passwordField;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *spinner;
@property (nonatomic, retain) IBOutlet NSTextField *emailLabel;
@property (nonatomic, retain) IBOutlet NSTextField *passwordLabel;
@property (nonatomic, retain) IBOutlet NSObjectController *sharedUserController;

@end
