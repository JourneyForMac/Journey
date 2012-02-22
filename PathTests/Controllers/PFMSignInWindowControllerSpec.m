#import "TestHelper.h"
#import "PFMSignInWindowController.h"
#import "PFMMainWindowController.h"
#import "PathAppDelegate.h"
#import "PFMHelper.h"

SpecBegin(PFMSignInWindowController)

__block PFMSignInWindowController *controller;
__block PFMUser *user;
__block id mockUser;

before(^{
  resetUserDefaultsAndKeychain();
  user = [NSApp resetSharedUser];
  mockUser = [OCMockObject partialMockForObject:user];
  controller = [PFMSignInWindowController new];
  [[controller window] makeKeyAndOrderFront:nil];
});

after(^{
  [controller close];
});

it(@"loads SignInWindow nib", ^{
  expect([controller windowNibName]).toEqual(@"SignInWindow");
});

it(@"sets itself to be the shared user's sign in delegate", ^{
  expect(user.signInDelegate).toEqual(controller);
});

describe(@"bindings", ^{
  describe(@"email field", ^{
    it(@"is bound to shared user object's email property", ^{
      user.email = @"lol@hahaha.com";
      expect([controller.emailField stringValue]).toEqual(@"lol@hahaha.com");
    });
  });

  describe(@"password field", ^{
    it(@"is bound to shared user object's password property", ^{
      user.password = @"R3A11yD|ff|cU17P@55w0rD";
      expect([controller.passwordField stringValue]).toEqual(@"R3A11yD|ff|cU17P@55w0rD");
    });
  });

  context(@"when the shared user's email and password properties are filled up", ^{
    before(^{
      user.email = @"foo@bar.com";
      user.password = @"123456";
    });

    it(@"enables sign in button", ^{
      expect([controller.signInButton isEnabled]).toEqual(YES);
    });

    context(@"when the shared user's email property is nil", ^{
      before(^{
        user.email = nil;
      });

      it(@"disables sign in button", ^{
        expect([controller.signInButton isEnabled]).toEqual(NO);
      });
    });

    context(@"when the shared user's password property is nil", ^{
      before(^{
        user.password = nil;
      });

      it(@"disables sign in button", ^{
        expect([controller.signInButton isEnabled]).toEqual(NO);
      });
    });

    context(@"when the shared user's signingIn property is YES", ^{
      before(^{
        user.signingIn = YES;
      });

      it(@"disables sign in button", ^{
        expect([controller.signInButton isEnabled]).toEqual(NO);
      });

      it(@"disables the text fields", ^{
        expect([controller.signInButton isEnabled]).toEqual(NO);
        expect([controller.signInButton isEnabled]).toEqual(NO);
      });
    });
  });

  describe(@"spinner", ^{
    it(@"is hidden and by default (user is not signing in)", ^{
      expect([controller.spinner isHidden]).toEqual(YES);
    });

    context(@"when user is signing in", ^{
      before(^{
        user.signingIn = YES;
      });

      it(@"is shown", ^{
        expect([controller.spinner isHidden]).toEqual(NO);
      });
    });
  });
});

describe(@"actions", ^{
  context(@"clicking on the sign in button", ^{
    it(@"sends -signIn message to the shared user", ^{
      [[mockUser expect] signIn];
      [controller.signInButton setEnabled:YES];
      [controller.signInButton performClick:nil];
      [mockUser verify];
    });
  });
});

describe(@"PFMUserSignInDelegate", ^{
  describe(@"-didSignIn", ^{
    __block id windowController;

    before(^{
      [controller didSignIn];
      windowController = [[[NSApp orderedWindows] objectAtIndex:0] windowController];
    });

    it(@"opens main window controller", ^{
      expect(((PathAppDelegate *)[NSApp delegate]).mainWindowController).toBeIdenticalTo(windowController);
      expect(windowController).toBeKindOf([PFMMainWindowController class]);
      expect([[windowController window] isVisible]).toEqual(YES);
    });

    after(^{
      [[windowController window] close];
    });
  });

  describe(@"-didFailSignInDueToInvalidCredentials", ^{
    it(@"shows alert sheet", ^{
      id mockHelper = [OCMockObject partialMockForObject:[PFMHelper helper]];
      [[mockHelper expect] showAlertSheetWithTitle:(id)containsString(@"Failed") message:(id)containsString(@"password") window:OCMOCK_ANY];
      [controller didFailSignInDueToInvalidCredentials];
      [mockHelper verify];
    });
  });

  describe(@"-didFailSignInDueToRequestError", ^{
    it(@"shows alert sheet", ^{
      id mockHelper = [OCMockObject partialMockForObject:[PFMHelper helper]];
      [[mockHelper expect] showAlertSheetWithTitle:(id)containsString(@"Failed") message:(id)containsString(@"Internet connection") window:OCMOCK_ANY];
      [controller didFailSignInDueToRequestError];
      [mockHelper verify];
    });
  });

  describe(@"-didFailSignInDueToPathError", ^{
    it(@"shows alert sheet", ^{
      id mockHelper = [OCMockObject partialMockForObject:[PFMHelper helper]];
      [[mockHelper expect] showAlertSheetWithTitle:(id)containsString(@"Failed") message:(id)containsString(@"Unable to login") window:OCMOCK_ANY];
      [controller didFailSignInDueToPathError];
      [mockHelper verify];
    });
  });
});

describe(@"auto sign in", ^{
  context(@"when the user's credentials are saved", ^{
    before(^{
      user.email = @"foo@bar.com";
      user.password = @"123456";
      [user saveCredentials];
      user.email = nil;
      user.password = nil;
    });

    context(@"on -windowDidLoad", ^{
      it(@"loads credentials and then sends -signIn message to the user", ^{
        [[mockUser expect] signIn];
        [controller windowDidLoad];
        expect(user.email).toEqual(@"foo@bar.com");
        expect(user.password).toEqual(@"123456");
        [mockUser verify];
      });
    });
  });

  context(@"when the user's credentials aren't found", ^{
    before(^{
      user.email = nil;
      user.password = nil;
      [user saveCredentials];
    });

    context(@"on -windowDidLoad", ^{
      it(@"does not send -signIn message to the user", ^{
        [[mockUser reject] signIn];
        [controller windowDidLoad];
        [mockUser verify];
      });
    });
  });
});

SpecEnd
