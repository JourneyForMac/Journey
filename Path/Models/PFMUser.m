#import "PFMUser.h"
#import "PFMMoment.h"
#import "PFMComment.h"
#import "Application.h"
#import "SBJson.h"
#import "SSKeychain.h"
#import "PFMPhoto.h"
#import "PFMLocation.h"
#import "PFMPlace.h"

@interface PFMUser ()

- (ASIHTTPRequest *)fetchMomentsWithPath:(NSString *)path;

@end

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
  [request addBasicAuthenticationHeaderWithUsername:self.email andPassword:self.password];

  [request setCompletionBlock:^{
    if(request.responseStatusCode == 200) {
      NSDictionary *dict = [[request responseString] JSONValue];
      self.firstName = [[dict objectOrNilForKey:@"settings"] objectOrNilForKey:@"user_first_name"];
      self.lastName  = [[dict objectOrNilForKey:@"settings"] objectOrNilForKey:@"user_last_name"];
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

- (ASIHTTPRequest *)fetchMomentsNewerThan:(NSDate *)date {
  NSString * path = nil;

  if (date != nil) {
    path = $str(@"%@?newer_than=%f", kMomentsAPIPath, [date timeIntervalSince1970]);
  } else {
    path = kMomentsAPIPath;
  }

  return [self fetchMomentsWithPath:path];
}

- (ASIHTTPRequest *)fetchMomentsOlderThan:(NSDate *)date {
  NSString * path = nil;

  if (date) {
    path = $str(@"%@?older_than=%f", kMomentsAPIPath, [date timeIntervalSince1970]);
  } else {
    path = kMomentsAPIPath;
  }

  return [self fetchMomentsWithPath:path];
}


- (ASIHTTPRequest *)fetchMomentsWithPath:(NSString *)path {
  self.fetchingMoments = YES;

  __block ASIHTTPRequest * request = [self requestWithPath:path];

  [request addBasicAuthenticationHeaderWithUsername:self.email andPassword:self.password];

  [request setCompletionBlock:^{
    if(request.responseStatusCode == 200) {
      [self parseMomentsJSON:[request responseString]];

      [self.momentsDelegate didFetchMoments:[self fetchedMoments]];
    } else {
      // Delegate method for Home Feed
    }
    self.fetchingMoments = NO;
  }];

  [request startAsynchronous];
  return request;
}

- (void)parseMomentsJSON:(NSString *)json {
  self.fetchedMoments = $marr(nil);
  NSDictionary *dict = [json JSONValue];
  for(NSDictionary * rawMoment in [dict objectOrNilForKey:@"moments"]) {
    PFMMoment * moment = [PFMMoment momentFrom:rawMoment];
    [self.fetchedMoments addObject:moment];
  }

  // Set the ID
  self.id = [(NSDictionary *)[(NSDictionary *)[dict objectOrNilForKey:@"cover"] objectOrNilForKey:@"user"] objectOrNilForKey:@"id"];
  // Get the Cover Photo
  NSDictionary * coverPhotoDictionary = [(NSDictionary *)[dict objectOrNilForKey:@"cover"] objectOrNilForKey:@"photo"];
  self.coverPhoto = [PFMPhoto photoFrom:coverPhotoDictionary];
  // Get the Profile Photo dictionary from the users dictionary and set the profile photo
  NSDictionary * profilePhotoDictionary = [(NSDictionary *)[(NSDictionary *)[dict objectOrNilForKey:@"users"] objectOrNilForKey:self.id] objectOrNilForKey:@"photo"];
  self.profilePhoto = [PFMPhoto photoFrom:profilePhotoDictionary];
  // Get the locations map
  NSDictionary * locationsDict = (NSDictionary *)[dict objectOrNilForKey:@"locations"];

  [locationsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    PFMLocation * location = [PFMLocation locationFrom:(NSDictionary *)obj];
    [[NSApp sharedLocations] setObject:location forKey:key];
  }];

  // Get the places map
  NSDictionary * placesDict = (NSDictionary *)[dict objectOrNilForKey:@"places"];

  [placesDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    PFMPlace * place = [PFMPlace placeFrom:(NSDictionary *)obj];
    [[NSApp sharedPlaces] setObject:place forKey:key];
  }];

  // Get the global users map
  NSDictionary * usersDict = (NSDictionary *)[dict objectOrNilForKey:@"users"];
  [usersDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    NSDictionary * userDict = (NSDictionary *)obj;
    NSString * userId = (NSString *)key;

    PFMUser * user = [PFMUser new];
    user.id = userId;
    user.firstName    = [userDict objectOrNilForKey:@"first_name"];
    user.lastName     = [userDict objectOrNilForKey:@"last_name"];
    user.profilePhoto = [PFMPhoto photoFrom:[userDict objectOrNilForKey:@"photo"]];

    [[NSApp sharedUsers] setObject:user forKey:userId];
  }];
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
