#import "PFMUser.h"
#import "PFMMoment.h"
#import "PFMComment.h"
#import "Application.h"
#import "SBJson.h"
#import "SSKeychain.h"
#import "PFMPhoto.h"
#import "PFMLocation.h"
#import "PFMPlace.h"

@implementation PFMUser

@synthesize
  id=_id
, email=_email
, password=_password
, signingIn=_signingIn
, fetchingMoments=_fetchingMoments
, firstName=_firstName
, lastName=_lastName
, signInDelegate=_signInDelegate
, momentsDelegate=_momentsDelegate
, fetchedMoments=_fetchedMoments
, coverPhoto=_coverPhoto
, profilePhoto=_profilePhoto
;

- (ASIHTTPRequest *)signIn {
  self.signingIn = YES;
  __block ASIHTTPRequest *request = [self requestWithPath:@"/3/user/settings"];
  [request setUsername:self.email];
  [request setPassword:self.password];

  [request setCompletionBlock:^{
    if(request.responseStatusCode == 200) {
      NSDictionary *dict = [[request responseString] JSONValue];
      self.firstName = [$safe([dict $for:@"settings"]) $for:@"user_first_name"];
      self.lastName = [$safe([dict $for:@"settings"]) $for:@"user_last_name"];
      [self saveCredentials];
      [self.signInDelegate didSignIn];
    } else {
      [self.signInDelegate didFailSignInDueToInvalidCredentials];
    }
    self.signingIn = NO;
  }];

  [request setFailedBlock:^{
    [self.signInDelegate didFailSignInDueToRequestError];
    self.signingIn = NO;
  }];

  [request startAsynchronous];
  return request;
}

- (ASIHTTPRequest *)fetchMoments {
  self.fetchingMoments = YES;

  __block ASIHTTPRequest * request = [self requestWithPath:@"/3/moment/feed/home"];
  [request setUsername:self.email];
  [request setPassword:self.password];

  [request setCompletionBlock:^{
    if(request.responseStatusCode == 200) {
      self.fetchedMoments = $marr(nil);

      NSDictionary *dict = [[request responseString] JSONValue];
      for(NSDictionary * rawMoment in $safe([dict $for:@"moments"])) {
        PFMMoment * moment = [PFMMoment momentFrom:rawMoment];
        [self.fetchedMoments addObject:moment];
      }

      // Set the ID
      self.id = [(NSDictionary *)[(NSDictionary *)$safe([dict $for:@"cover"]) $for:@"user"] $for:@"id"];
      // Get the Cover Photo
      NSDictionary * coverPhotoDictionary = [(NSDictionary *)$safe([dict $for:@"cover"]) $for:@"photo"];
      self.coverPhoto = [PFMPhoto photoFrom:coverPhotoDictionary];
      // Get the Profile Photo dictionary from the users dictionary and set the profile photo
      NSDictionary * profilePhotoDictionary = [(NSDictionary *)[(NSDictionary *)$safe([dict $for:@"users"]) $for:self.id] $for:@"photo"];
      self.profilePhoto = [PFMPhoto photoFrom:profilePhotoDictionary];
      // Get the locations map
      NSDictionary * locationsDict = (NSDictionary *)$safe([dict $for:@"locations"]);

      [locationsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        PFMLocation * location = [PFMLocation locationFrom:(NSDictionary *)obj];
        [[NSApp sharedLocations] setObject:location forKey:key];
      }];

      // Get the places map
      NSDictionary * placesDict = (NSDictionary *)$safe([dict $for:@"places"]);

      [placesDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        PFMPlace * place = [PFMPlace placeFrom:(NSDictionary *)obj];
        [[NSApp sharedPlaces] setObject:place forKey:key];
      }];

      // Get the global users map
      NSDictionary * usersDict = (NSDictionary *)$safe([dict $for:@"users"]);
      [usersDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary * userDict = (NSDictionary *)obj;
        NSString * userId = (NSString *)key;

        PFMUser * user = [PFMUser new];
        user.id = userId;
        user.firstName = $safe([userDict $for:@"first_name"]);
        user.lastName = $safe([userDict $for:@"last_name"]);
        user.profilePhoto = [PFMPhoto photoFrom:$safe([userDict $for:@"photo"])];

        [[NSApp sharedUsers] setObject:user forKey:userId];
      }];


      [self.momentsDelegate didFetchMoments:[self fetchedMoments]];
    } else {
      // Delegate method for Home Feed
    }
    self.fetchingMoments = NO;
  }];

  [request startAsynchronous];
  return request;
}

- (void)saveCredentials {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:self.email forKey:kPathDefaultsEmailKey];
  [defaults synchronize];
  [SSKeychain setPassword:self.password forService:kPathKeychainServiceName account:self.email];
}

- (void)loadCredentials {
  self.email = [[NSUserDefaults standardUserDefaults] objectForKey:kPathDefaultsEmailKey];
  self.password = [SSKeychain passwordForService:kPathKeychainServiceName account:self.email];
}

- (NSDictionary *) toHash {
  NSMutableDictionary * userDict = $mdict(self.id, @"id");

  [userDict setObjectOrNil:self.email                 forKey:@"email"];
  [userDict setObjectOrNil:self.firstName             forKey:@"firstName"];
  [userDict setObjectOrNil:self.lastName              forKey:@"lastName"];
  [userDict setObjectOrNil:[self.coverPhoto toHash]   forKey:@"coverPhoto"];
  [userDict setObjectOrNil:[self.profilePhoto toHash] forKey:@"profilePhoto"];

  return userDict;
}

- (NSString *) JSONRepresentation {
  return [[self toHash] JSONRepresentation];
}

@end
