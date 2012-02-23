#import "Application.h"
#import "PFMSignInWindowController.h"
#import "PFMMainWindowController.h"
#import "PFMHelper.h"
#import "PFMRedLinenView.h"
#import "PathAppDelegate.h"

@implementation PFMSignInWindowController

@synthesize
  signInButton=_signInButton
, emailField=_emailField
, passwordField=_passwordField
, spinner=_spinner
, emailLabel=_emailLabel
, passwordLabel=_passwordLabel
;

- (id)init {
  self = [super initWithWindowNibName:@"SignInWindow"];
  return self;
}

- (void)awakeFromNib {
  NSSize initialWindowSize = [[self window] frame].size;
  NSRect screenFrame = [[NSScreen mainScreen] frame];
  [self.window setFrame:NSMakeRect((screenFrame.size.width - initialWindowSize.width) / 2.0
                                 , (screenFrame.size.height - initialWindowSize.height) / 2.0
                                 , initialWindowSize.width, initialWindowSize.height) display:NO];
}

- (void)windowDidLoad {
  [super windowDidLoad];

  PFMUser *user = [NSApp sharedUser];
  user.signInDelegate = self;
  [user loadCredentials];
  if(user.email && user.password) {
    [user signIn];
  }
}

- (IBAction)didClickOnSignInButton:(id)sender {
  [[NSApp sharedUser] signIn];
}

#pragma mark - PFMUserSignInDelegate

- (void)didSignIn {
  [self close];
  PathAppDelegate *appDelegate = [NSApp delegate];
  appDelegate.mainWindowController = [PFMMainWindowController new];
  NSWindow *window = [appDelegate.mainWindowController window];
  [window focus];
}

- (void)didFailSignInDueToInvalidCredentials {
  [[PFMHelper helper] showAlertSheetWithTitle:@"Failed to sign in!" message:@"You have entered invalid email and/or password." window:[self window]];
  [[self window] makeFirstResponder:self.emailField];
}

- (void)didFailSignInDueToRequestError {
  [[PFMHelper helper] showAlertSheetWithTitle:@"Failed to sign in!" message:@"An error occured while trying to connect to the server. Please check your Internet connection and try again." window:[self window]];
}

- (void)didFailSignInDueToPathError {
  [[PFMHelper helper] showAlertSheetWithTitle:@"Failed to sign in!" message:@"Unable to login at this time. Please try again later." window:[self window]];
}

@end
