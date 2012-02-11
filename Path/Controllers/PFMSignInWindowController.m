#import "Application.h"
#import "PFMSignInWindowController.h"
#import "PFMMainWindowController.h"
#import "PFMHelper.h"
#import "PFMRedLinenView.h"

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

  NSView *contentView = [[self window] contentView];
  NSView *themeFrame = [contentView superview];
  PFMRedLinenView *backgroundView = [[PFMRedLinenView alloc] initWithFrame:[themeFrame frame]];
  [themeFrame addSubview:backgroundView positioned:NSWindowBelow relativeTo:[[themeFrame subviews] objectAtIndex:0]];

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
  PFMMainWindowController *mainWindowController = [PFMMainWindowController new];
  [[self window] close];
  [[mainWindowController window] makeKeyAndOrderFront:nil];
}

- (void)didFailSignInDueToInvalidCredentials {
  [[PFMHelper helper] showAlertSheetWithTitle:@"Failed to sign in!" message:@"You have entered invalid email and/or password." window:[self window]];
  [[self window] makeFirstResponder:self.emailField];
}

- (void)didFailSignInDueToRequestError {
  [[PFMHelper helper] showAlertSheetWithTitle:@"Failed to sign in!" message:@"An error occured while trying to connect to the server. Please check your Internet connection and try again." window:[self window]];
}

- (void)didFetchMoments {

}

@end
