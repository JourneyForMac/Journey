#import "TestHelper.h"
#import "PFMUser.h"
#import "SSKeychain.h"
#import "ASIHTTPRequest+Spec.h"
#import "PFMMoment.h"
#import "PFMPhoto.h"

SpecBegin(PFMUser)

__block PFMUser *user;
__block id mockUser;

before(^{
  resetUserDefaultsAndKeychain();
  user = [PFMUser new];
  mockUser = [OCMockObject partialMockForObject:user];
  user.email = @"foo@bar.com";
  user.password = @"123456";
});

describe(@"-signIn", ^{
  __block ASIHTTPRequest *request;
  __block id mockRequest;
  __block id mockSignInDelegate;

  before(^{
    request = [user signIn];
    mockRequest = [OCMockObject partialMockForObject:request];
    mockSignInDelegate = [OCMockObject mockForProtocol:@protocol(PFMUserSignInDelegate)];
  });

  it(@"sets user's signingIn property to be YES", ^{
    expect(user.signingIn).toEqual(YES);
  });

  it(@"makes an asynchronous GET request to /3/user/settings", ^{
    expect([request.url relativePath]).toContain(@"/3/user/settings");
    expect(request.started).toEqual(YES);
    expect(request.asynchronous).toEqual(YES);
  });

  describe(@"when the request is completed", ^{
    before(^{
      [[[mockRequest stub] andReturn:loadStringFixture(@"settings.json")] responseString];
    });

    void (^doAction)(void) = ^{
      [request completionBlock]();
    };

    context(@"when the response code is 200", ^{
      before(^{
        int responseStatusCode = 200;
        [[[mockRequest stub] andReturnValue:OCMOCK_VALUE(responseStatusCode)] responseStatusCode];
      });

      it(@"makes request with basic auth", ^{
        doAction();
        expect(request.username).toEqual(@"foo@bar.com");
        expect(request.password).toEqual(@"123456");
      });

      it(@"sets firstName and lastName", ^{
        doAction();
        expect(user.firstName).toEqual(@"Foo");
        expect(user.lastName).toEqual(@"Bar");
      });

      it(@"persists the user", ^{
        [[mockUser expect] saveCredentials];
        doAction();
        [mockUser verify];
      });

      it(@"sends -didSignIn message to the signInDelegate", ^{
        user.signInDelegate = mockSignInDelegate;
        [[mockSignInDelegate expect] didSignIn];
        doAction();
        [mockSignInDelegate verify];
      });

      it(@"sets user's signingIn property to be NO", ^{
        doAction();
        expect(user.signingIn).toEqual(NO);
      });
    });

    context(@"when the response code is 403", ^{
      before(^{
        int responseStatusCode = 403;
        [[[mockRequest stub] andReturnValue:OCMOCK_VALUE(responseStatusCode)] responseStatusCode];
      });

      it(@"sends -didFailSignInDueToInvalidCredentials message to the signInDelegate", ^{
        user.signInDelegate = mockSignInDelegate;
        [[mockSignInDelegate expect] didFailSignInDueToInvalidCredentials];
        doAction();
        [mockSignInDelegate verify];
      });

      it(@"sets user's signingIn property to be NO", ^{
        doAction();
        expect(user.signingIn).toEqual(NO);
      });
    });
  });

  describe(@"when the request fails", ^{
    void (^doAction)(void) = ^{
      [request failureBlock]();
    };

    it(@"sends -didFailSignInDueToRequestError message to the signInDelegate", ^{
      user.signInDelegate = mockSignInDelegate;
      [[mockSignInDelegate expect] didFailSignInDueToRequestError];
      doAction();
      [mockSignInDelegate verify];
    });

    it(@"sets user's signingIn property to be NO", ^{
      doAction();
      expect(user.signingIn).toEqual(NO);
    });
  });
});

describe(@"-saveCredentials", ^{
  before(^{
    [user saveCredentials];
  });

  it(@"saves the email in user defaults", ^{
    expect([[NSUserDefaults standardUserDefaults] objectForKey:kPathDefaultsEmailKey]).toEqual(@"foo@bar.com");
  });

  it(@"saves the password in the keychain", ^{
    expect([SSKeychain passwordForService:kPathKeychainServiceName account:user.email]).toEqual(@"123456");
  });
});

describe(@"-loadCredentials", ^{
  before(^{
    [user saveCredentials];
    user.email = nil;
    user.password = nil;
    [user loadCredentials];
  });

  it(@"loads the email from user defaults", ^{
    expect(user.email).toEqual(@"foo@bar.com");
  });

  it(@"loads the password from the keychain", ^{
    expect(user.password).toEqual(@"123456");
  });
});

describe(@"-fetchMoments", ^{
  __block ASIHTTPRequest *request;
  __block id mockRequest;
  __block id mockMomentsDelegate;

  before(^{
    request = [user fetchMoments];
    mockRequest = [OCMockObject partialMockForObject:request];
    mockMomentsDelegate = [OCMockObject mockForProtocol:@protocol(PFMUserMomentsDelegate)];
  });

  it(@"sets user's fetchingMoments property to be YES", ^{
    expect(user.fetchingMoments).toEqual(YES);
  });

  it(@"makes an asynchronous GET request to /3/moment/feed/home", ^{
    expect([request.url relativePath]).toContain(@"/3/moment/feed/home");
    expect(request.started).toEqual(YES);
    expect(request.asynchronous).toEqual(YES);
  });

  describe(@"when the request is completed", ^{
    before(^{
      [[[mockRequest stub] andReturn:loadStringFixture(@"moments_feed.json")] responseString];
    });

    void (^doAction)(void) = ^{
      [request completionBlock]();
    };

    context(@"when the response code is 200", ^{
      before(^{
        int responseStatusCode = 200;
        [[[mockRequest stub] andReturnValue:OCMOCK_VALUE(responseStatusCode)] responseStatusCode];
      });

      it(@"makes request with basic auth", ^{
        doAction();
        expect(request.username).toEqual(@"foo@bar.com");
        expect(request.password).toEqual(@"123456");
      });

      it(@"populates the fetchedMoments array with the moments fetched from the API", ^{
        doAction();
        expect([user.fetchedMoments count]).toEqual(11);
      });

      it(@"sets the cover photo of the user", ^{
        doAction();
        expect([user.coverPhoto webURL]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/web.jpg");
        expect([user.coverPhoto originalURL]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/original.jpg");
        expect([user.coverPhoto iOSLowResURL]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/1x.jpg");
        expect([user.coverPhoto iOSHighResURL]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/2x.jpg");

      });


      it(@"sends -didFetchMoments message to the userdelegate", ^{
        user.momentsDelegate = mockMomentsDelegate;
        [[mockMomentsDelegate expect] didFetchMoments:[OCMArg checkWithBlock:^BOOL (id obj) {
          expect(obj).toEqual(user.fetchedMoments);
          return YES;
        }]];
        doAction();
        [mockMomentsDelegate verify];
        PFMMoment *moment = [user.fetchedMoments lastObject];
        expect(moment.id).toEqual(@"4f338c49f6b766128d011178");
        expect(moment.userId).toEqual(@"4f338c49f6b766128d011175");
        expect(moment.locationId).toEqual(@"4f34078be7cf662b9d09e2d2");
        expect(moment.type).toEqual(@"ambient");
        expect(moment.headline).toEqual(@"Joined Path");
        expect(moment.subHeadline).toEqual(@"On February 9th, 2012");
        expect(moment.thought).toEqual(@"this is cool");
        expect(moment.state).toEqual(@"live");
        expect(moment.shared).toEqual(false);
        expect(moment.private).toEqual(false);
        expect(moment.createdAt).toEqual([NSDate dateWithTimeIntervalSince1970:1328778313]);
      });

      it(@"sets user's fetchingMoments property to be NO", ^{
        doAction();
        expect(user.fetchingMoments).toEqual(NO);
      });
    });
  });

});

SpecEnd
