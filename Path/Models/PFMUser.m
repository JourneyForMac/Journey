#import "PFMUser.h"
#import "PFMMoment.h"
#import "Application.h"
#import "SBJson.h"
#import "SSKeychain.h"
#import "PFMPhoto.h"

@interface PFMUser ()

- (PFMPhoto *) photoFrom:(NSDictionary *)coverPhoto;

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
        PFMMoment * moment = [PFMMoment new];
        moment.id = $safe([rawMoment $for:@"id"]);
        moment.locationId = $safe([rawMoment $for:@"location_id"]);
        moment.userId = $safe([rawMoment $for:@"user_id"]);

        moment.type = $safe([rawMoment $for:@"type"]);
        moment.headline = $safe([rawMoment $for:@"headline"]);
        moment.subHeadline = $safe([rawMoment $for:@"subheadline"]);
        moment.thought = $safe([rawMoment $for:@"thought"]);
        moment.state = $safe([rawMoment $for:@"state"]);
        moment.createdAt = [NSDate dateWithTimeIntervalSince1970:floor([$safe([rawMoment $for:@"created"]) doubleValue])];
        moment.private = [(NSNumber *)[rawMoment $for:@"private"] boolValue];
        moment.shared =  [(NSNumber *)[rawMoment $for:@"shared"] boolValue];

        [self.fetchedMoments addObject:moment];
      }

      // Set the ID
      self.id = [(NSDictionary *)[(NSDictionary *)$safe([dict $for:@"cover"]) $for:@"user"] $for:@"id"];
      // Get the Cover Photo
      NSDictionary * coverPhoto = [(NSDictionary *)$safe([dict $for:@"cover"]) $for:@"photo"];
      self.coverPhoto = [self photoFrom:coverPhoto];
      // Get the Profile Photo dictionary from the users dictionary and set the profile photo
      NSDictionary * profilePhoto = [(NSDictionary *)[(NSDictionary *)$safe([dict $for:@"users"]) $for:self.id] $for:@"photo"];
      self.profilePhoto = [self photoFrom:profilePhoto];

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

#pragma mark -
#pragma mark Private Methods

- (PFMPhoto *) photoFrom:(NSDictionary *)coverPhoto {
  PFMPhoto * photo = [PFMPhoto new];
  photo.baseURL = $safe([coverPhoto $for:@"url"]);
  NSDictionary * iOSDetails = (NSDictionary *)[coverPhoto $for:@"ios"];

  photo.iOSHighResFileName = [(NSDictionary *)[iOSDetails $for:@"2x"] $for:@"file"];
  photo.iOSLowResFileName = [(NSDictionary *)[iOSDetails $for:@"1x"] $for:@"file"];
  photo.webFileName = [(NSDictionary *)[coverPhoto $for:@"web"] $for:@"file"];
  photo.originalFileName = [(NSDictionary *)[coverPhoto $for:@"original"] $for:@"file"];

  return photo;
}

@end
