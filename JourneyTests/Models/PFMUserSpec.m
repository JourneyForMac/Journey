#import "TestHelper.h"
#import "PFMUser.h"
#import "SSKeychain.h"
#import "PFMMoment.h"
#import "PFMPhoto.h"
#import "PFMComment.h"
#import "PFMLocation.h"
#import "PFMPlace.h"
#import "SBJson.h"

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
    [user signIn];
    request = [ASIHTTPRequest mostRecentRequest];
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

  it(@"makes request with basic auth", ^{
    expect([request.requestHeaders allKeys]).toContain(@"Authorization");
    expect([request.requestHeaders objectForKey:@"Authorization"]).toContain(@"Basic");
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

      it(@"sets user's signedIn property to YES", ^{
        doAction();
        expect(user.signedIn).toEqual(YES);
      });

      it(@"sets user's signingIn property to NO", ^{
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

      it(@"sets user's signingIn property to NO", ^{
        doAction();
        expect(user.signingIn).toEqual(NO);
      });
    });

    context(@"when the response code is 500", ^{
      before(^{
        int responseStatusCode = 500;
        [[[mockRequest stub] andReturnValue:OCMOCK_VALUE(responseStatusCode)] responseStatusCode];
      });

      it(@"sends -didFailSignInDueToInvalidCredentials message to the signInDelegate", ^{
        user.signInDelegate = mockSignInDelegate;
        [[mockSignInDelegate expect] didFailSignInDueToPathError];
        doAction();
        [mockSignInDelegate verify];
      });

      it(@"sets user's signingIn property to NO", ^{
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

    it(@"sets user's signingIn property to NO", ^{
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

describe(@"-deleteCredentials", ^{
  before(^{
    user.oid = @"";
    user.signedIn = YES;
    user.signingIn = YES;
    user.fetchingMoments = YES;
    user.firstName = @"";
    user.lastName = @"";
    user.allMomentIds = $dict(@"v",@"k");
    user.allMoments = $arr([PFMMoment new]);
    user.fetchedMoments = $arr(@"");
    user.coverPhoto = [PFMPhoto new];
    user.profilePhoto = [PFMPhoto new];
    [user saveCredentials];
    [user deleteCredentials];
  });

  it(@"removes the email in user defaults", ^{
    expect([[NSUserDefaults standardUserDefaults] objectForKey:kPathDefaultsEmailKey]).toBeNil();
  });

  it(@"removes the keychain entry", ^{
    expect([SSKeychain passwordForService:kPathKeychainServiceName account:user.email]).toBeNil();
  });

  it(@"resets the user object", ^{
    expect(user.oid).toBeNil();
    expect(user.email).toBeNil();
    expect(user.password).toBeNil();
    expect(user.signedIn).toEqual(NO);
    expect(user.signingIn).toEqual(NO);
    expect(user.fetchingMoments).toEqual(NO);
    expect(user.firstName).toBeNil();
    expect(user.lastName).toBeNil();
    expect([user.allMomentIds count]).toEqual(0);
    expect([user.allMoments count]).toEqual(0);
    expect(user.fetchedMoments).toBeNil();
    expect(user.coverPhoto).toBeNil();
    expect(user.profilePhoto).toBeNil();
  });
});

describe(@"-fetchMomentsNewerThan: (non-null Date)", ^{
  __block ASIHTTPRequest *request;
  __block id mockRequest;
  __block id mockMomentsDelegate;

  before(^{
    [user fetchMomentsNewerThan:1328809735.59837];
    request = [ASIHTTPRequest mostRecentRequest];
    mockRequest = [OCMockObject partialMockForObject:request];
    mockMomentsDelegate = [OCMockObject mockForProtocol:@protocol(PFMUserMomentsDelegate)];
    // There are already moments loaded as part of the user
    [user parseMomentsJSON:loadStringFixture(@"moments_feed.json") insertAtTop:YES];
  });

  after(^{
    [NSApp resetSharedUsers];
    [NSApp resetSharedLocations];
    [NSApp resetSharedPlaces];
    [NSApp resetSharedLocations];
  });

  it(@"makes an asynchronous GET request to /3/moment/feed/home?newer_than=1328809735.59837", ^{
    expect([request.url relativePath]).toContain(@"/3/moment/feed/home");
    expect([request.url query]).toContain(@"newer_than=1328809735.59837");
    expect(request.started).toEqual(YES);
    expect(request.asynchronous).toEqual(YES);
  });

  describe(@"when the request is completed", ^{
    before(^{
      // This feed contains one moment which has been already initialized in the allMomentIds hash
      // so it wont be added to fetchedMoments
      [[[mockRequest stub] andReturn:loadStringFixture(@"moments_feed_newer_than.json")] responseString];
    });

    void (^doAction)(void) = ^{
      [request completionBlock]();
    };

    context(@"when the response code is 200", ^{
      before(^{
        int responseStatusCode = 200;
        [[[mockRequest stub] andReturnValue:OCMOCK_VALUE(responseStatusCode)] responseStatusCode];
      });

      it(@"populates the fetchedMoments array with the new moments fetched from the API", ^{
        doAction();
        expect([user.fetchedMoments count]).toEqual(1);
      });

      it(@"populates the allMoments array with the all moments fetched so far", ^{
        doAction();
        expect([user.allMoments count]).toEqual(13);
      });
    });
  });
});

describe(@"-fetchMomentsOlderThan: (non-null Date)", ^{
  __block ASIHTTPRequest *request;
  __block id mockRequest;
  __block id mockMomentsDelegate;

  before(^{
    [user fetchMomentsOlderThan:1328778313.41825];
    request = [ASIHTTPRequest mostRecentRequest];
    mockRequest = [OCMockObject partialMockForObject:request];
    mockMomentsDelegate = [OCMockObject mockForProtocol:@protocol(PFMUserMomentsDelegate)];
    [user parseMomentsJSON:loadStringFixture(@"moments_feed.json") insertAtTop:YES];
  });

  after(^{
    [NSApp resetSharedUsers];
    [NSApp resetSharedLocations];
    [NSApp resetSharedPlaces];
    [NSApp resetSharedLocations];
  });

  it(@"makes an asynchronous GET request to /3/moment/feed/home?older_than=1328778313.41825", ^{
    expect([request.url relativePath]).toContain(@"/3/moment/feed/home");
    expect([request.url query]).toContain(@"older_than=1328778313.41825");
    expect(request.started).toEqual(YES);
    expect(request.asynchronous).toEqual(YES);
  });

  describe(@"when the request is completed", ^{
    before(^{
      // This feed contains one moment which has been already initialized in the allMomentIds hash
      // so it wont be added to fetchedMoments
      [[[mockRequest stub] andReturn:loadStringFixture(@"moments_feed_older_than.json")] responseString];
    });

    void (^doAction)(void) = ^{
      [request completionBlock]();
    };

    context(@"when the response code is 200", ^{
      before(^{
        int responseStatusCode = 200;
        [[[mockRequest stub] andReturnValue:OCMOCK_VALUE(responseStatusCode)] responseStatusCode];
      });

      it(@"populates the fetchedMoments array with the new moments fetched from the API", ^{
        doAction();
        expect([user.fetchedMoments count]).toEqual(1);
      });

      it(@"populates the allMoments array with the all moments fetched so far", ^{
        doAction();
        expect([user.allMoments count]).toEqual(13);
      });
    });
  });
});

describe(@"-fetchMomentsNewerThan:/-fetchMomentsOlderThan: (with nil date)", ^{
  __block ASIHTTPRequest *request;
  __block id mockRequest;
  __block id mockMomentsDelegate;

  before(^{
    [user fetchMomentsNewerThan:0.0];
    request = [ASIHTTPRequest mostRecentRequest];
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

  it(@"makes request with basic auth", ^{
    expect([request.requestHeaders allKeys]).toContain(@"Authorization");
    expect([request.requestHeaders objectForKey:@"Authorization"]).toContain(@"Basic");
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

      it(@"populates the fetchedMoments array with the moments fetched from the API", ^{
        doAction();
        expect([user.fetchedMoments count]).toEqual(12);
      });

      it(@"sets the cover photo of the user", ^{
        doAction();
        expect([user.coverPhoto webURL]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/web.jpg");
        expect([user.coverPhoto originalURL]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/original.jpg");
        expect([user.coverPhoto iOSLowResURL]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/1x.jpg");
        expect([user.coverPhoto iOSHighResURL]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/2x.jpg");
      });

      it(@"sets the id of the user", ^{
        doAction();
        expect(user.oid).toEqual(@"4f338c49f6b766128d011175");
      });

      it(@"sets the profile photo of the user", ^{
        doAction();
        expect(user.profilePhoto.iOSLowResURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/profile_photos/bef62e4fdd1b2a4e1df408443fcb4e2cde6f2a03/processed_80x80.jpg");
        expect(user.profilePhoto.iOSHighResURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/profile_photos/bef62e4fdd1b2a4e1df408443fcb4e2cde6f2a03/processed_160x160.jpg");
        expect(user.profilePhoto.originalURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/profile_photos/bef62e4fdd1b2a4e1df408443fcb4e2cde6f2a03/original.jpg");
      });

      it(@"sends -didFetchMoments message to the userdelegate", ^{
        user.momentsDelegate = mockMomentsDelegate;
        [[mockMomentsDelegate expect] didFetchMoments:[OCMArg checkWithBlock:^BOOL (id obj) {
          expect(obj).toEqual(user.fetchedMoments);
          return YES;
        }] atTop:YES];
        doAction();
        [mockMomentsDelegate verify];
        PFMMoment *moment = [user.fetchedMoments lastObject];
        expect(moment.oid).toEqual(@"4f338c49f6b766128d011178");
        expect(moment.userId).toEqual(@"4f338c49f6b766128d011175");
        expect(moment.locationId).toEqual(@"4f34078be7cf662b9d09e2d2");
        expect(moment.type).toEqual(@"ambient");
        expect(moment.headline).toEqual(@"Joined Path");
        expect(moment.subHeadline).toEqual(@"On February 9th, 2012");
        expect(moment.thought).toEqual(@"this is cool");
        expect(moment.state).toEqual(@"live");
        expect(moment.shared).toEqual(false);
        expect(moment.private).toEqual(false);
        expect(moment.subType).toEqual(@"joined");

        expect((float)moment.createdAt).toEqual(1328778313.41825f);

        PFMMoment * momentWithPlace = (PFMMoment *)[user.fetchedMoments $at:8];
        expect(momentWithPlace.placeId).toEqual(@"4bcd4dc50687ef3b31c6e0cc");

        PFMMoment * momentWithPeople = (PFMMoment *)[user.fetchedMoments $at:([user.fetchedMoments count] - 2)];
        expect([momentWithPeople.people count]).toEqual(1);
      });

      it(@"sets the sharedLocations dictionary with id <-> location mapping", ^{
        doAction();
        expect([[NSApp sharedLocations] count]).toEqual(14);

        PFMLocation * location = [[NSApp sharedLocations] $for:@"4f33b224e7cf662ba2082b6b"];
        expect(location.oid).toEqual(@"4f33b224e7cf662ba2082b6b");
        expect(location.weatherConditions).toEqual(@"Mostly cloudy");
        expect(location.cloudCover).toEqual(@"75%");
        expect(location.windSpeed).toEqual(@"4 meters per second");
        expect(location.dewPoint).toEqual(@"66F");
        expect(location.temperature).toEqual(@"83F");
        expect(location.windDirection).toEqual(@"100 degrees");
        expect((float)location.latitude).toEqual(1.28618792453878f);
        expect((float)location.longitude).toEqual(103.849152707777f);
        expect((float)location.accuracy).toEqual(76.2130243463154f);
        expect((float)location.elevation).toEqual(41.0330467224121f);
        expect(location.countryName).toEqual(@"Singapore");
        expect(location.country).toEqual(@"SG");
        expect(location.city).toEqual(@"Singapore");
      });

      it(@"sets the sharedPlaces dictionary with id <-> place mapping", ^{
        doAction();
        expect([[NSApp sharedPlaces] count]).toEqual(1);

        PFMPlace * place = [[NSApp sharedPlaces] $for:@"4bcd4dc50687ef3b31c6e0cc"];
        expect(place.oid).toEqual(@"4bcd4dc50687ef3b31c6e0cc");
        expect(place.name).toEqual(@"Mescluns");
        expect(place.address).toEqual(@"64 Circular Road");
        expect(place.city).toEqual(@"Singapore");
        expect(place.country).toEqual(@"Singapore");
        expect(place.state).toEqual(@"Singapore");

        expect((float)place.latitude).toEqual(1.286237f);
        expect((float)place.longitude).toEqual(103.849196);
        expect(place.totalCheckins).toEqual(1);
        expect(place.phone).toEqual(@"+6562218141");
        expect(place.formattedPhone).toEqual(@"+65 6221 8141");
      });

      it(@"sets the sharedUsers dictionary with id <-> user mapping", ^{
        doAction();
        expect([[NSApp sharedUsers] count]).toEqual(2);

        PFMUser * user = [[NSApp sharedUsers] $for:@"4f338c49f6b766128d011175"];
        expect(user.oid).toEqual(@"4f338c49f6b766128d011175");
        expect(user.firstName).toEqual(@"Aloha");
        expect(user.lastName).toEqual(@"Boss");
        expect(user.profilePhoto.originalURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/profile_photos/bef62e4fdd1b2a4e1df408443fcb4e2cde6f2a03/original.jpg");
      });

      it(@"should assign photos to moments (if they exist)", ^{
        doAction();
        PFMMoment *moment = (PFMMoment *)[user.fetchedMoments $at:0];

        expect(moment.photo.iOSLowResURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/photos2/d5abf9a1-1217-418a-9188-b8be09b1026e/1x.jpg");
        expect(moment.photo.iOSHighResURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/photos2/d5abf9a1-1217-418a-9188-b8be09b1026e/2x.jpg");
        expect(moment.photo.originalURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/photos2/d5abf9a1-1217-418a-9188-b8be09b1026e/original.jpg");
      });

      it(@"should assign comments to moments (if they exist)", ^{
        doAction();
        PFMMoment *moment = (PFMMoment *)[user.fetchedMoments $at:0];

        expect([moment.comments count]).toEqual(2);

        PFMComment * comment1 = (PFMComment *)[moment.comments $at:0];
        PFMComment * comment2 = (PFMComment *)[moment.comments $at:1];

        expect(comment1.oid).toEqual(@"4f34078de7cf662b9d09e2d8");
        expect(comment1.body).toEqual(@"Hello");
        expect(comment1.userId).toEqual(@"4f338c49f6b766128d011175");
        expect(comment1.locationId).toEqual(@"4f34078be7cf662b9d09e2d2");
        expect(comment1.momentId).toEqual(@"4f34078de7cf662b9d09e2d7");
        expect(comment1.state).toEqual(@"live");
        expect(comment1.createdAt).toEqual([NSDate dateWithTimeIntervalSince1970:1328809735]);

        expect(comment2.oid).toEqual(@"4f343a20d2bfa87b380074de");
        expect(comment2.body).toEqual(@"xdt");
        expect(comment2.userId).toEqual(@"4f338c49f6b766128d011175");
        expect(comment2.locationId).toEqual(@"4f343a1fd2bfa87b380074dd");
        expect(comment2.momentId).toEqual(@"4f34078de7cf662b9d09e2d7");
        expect(comment2.state).toEqual(@"live");
        expect(comment2.createdAt).toEqual([NSDate dateWithTimeIntervalSince1970:1328822815]);
      });

      it(@"sets user's fetchingMoments property to be NO", ^{
        doAction();
        expect(user.fetchingMoments).toEqual(NO);
      });
    });

    context(@"When the response code is not 200 (404/500)", ^{
      before(^{
        int responseStatusCode = 500;
        [[[mockRequest stub] andReturnValue:OCMOCK_VALUE(responseStatusCode)] responseStatusCode];
      });

      after(^{
        [NSApp resetSharedUsers];
        [NSApp resetSharedLocations];
        [NSApp resetSharedPlaces];
        [NSApp resetSharedLocations];
      });

      it(@"should call the didFailToFetchMoments", ^{
        user.momentsDelegate = mockMomentsDelegate;
        [[mockMomentsDelegate expect] didFailToFetchMoments];
        doAction();
        [mockMomentsDelegate verify];
      });
    });
  });
});

describe(@"-JSONRepresentation", ^{
  before(^{
    user.firstName = @"Aloha";
    user.lastName = @"Boss";
    user.oid = @"user.id";

    PFMPhoto * coverPhoto = [PFMPhoto new];

    coverPhoto.iOSLowResFileName = @"1x.jpg";
    coverPhoto.iOSHighResFileName = @"2x.jpg";
    coverPhoto.webFileName = @"web.jpg";
    coverPhoto.originalFileName = @"original.jpg";
    coverPhoto.baseURL = @"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19";

    PFMPhoto * profilePhoto = [PFMPhoto new];

    profilePhoto.iOSLowResFileName = @"1x.jpg";
    profilePhoto.iOSHighResFileName = @"2x.jpg";
    profilePhoto.webFileName = @"web.jpg";
    profilePhoto.originalFileName = @"original.jpg";
    profilePhoto.baseURL = @"https://s3-us-west-1.amazonaws.com/images.path.com/static/profile/1";

    user.coverPhoto = coverPhoto;
    user.profilePhoto = profilePhoto;
  });

  it(@"should return a JSON representation of the user, including nested objects", ^{
    NSString * userJSON = [user JSONRepresentation];
    NSDictionary * userDict = [userJSON JSONValue];

    expect([userDict $for:@"id"]).toEqual(@"user.id");
    expect([userDict $for:@"email"]).toEqual(@"foo@bar.com");
    expect([userDict $for:@"firstName"]).toEqual(@"Aloha");
    expect([userDict $for:@"lastName"]).toEqual(@"Boss");

    expect([[userDict $for:@"profilePhoto"] $for:@"webURL"]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/profile/1/web.jpg");
    expect([[userDict $for:@"coverPhoto"] $for:@"webURL"]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/web.jpg");
  });
});

SpecEnd
