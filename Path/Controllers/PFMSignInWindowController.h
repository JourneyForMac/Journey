#import <Cocoa/Cocoa.h>
#import "PFMUser.h"

@interface PFMSignInWindowController : NSWindowController <
  PFMUserSignInDelegate
>

- (IBAction)didClickOnSignInButton:(id)sender;

@property (nonatomic, retain) IBOutlet NSButton *signInButton;
@property (nonatomic, retain) IBOutlet NSTextField *emailField;
@property (nonatomic, retain) IBOutlet NSTextField *passwordField;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *spinner;
@property (nonatomic, retain) IBOutlet NSTextField *emailLabel;
@property (nonatomic, retain) IBOutlet NSTextField *passwordLabel;

@end
