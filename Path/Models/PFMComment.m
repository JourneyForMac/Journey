#import "PFMComment.h"
#import "Application.h"
#import "PFMLocation.h"
#import "SBJson.h"

@implementation PFMComment

@synthesize
  oid=_oid
, userId=_userId
, locationId=_locationId
, momentId=_momentId
, body=_body
, state=_state
, createdAt=_createdAt;

+ (PFMComment *)commentFrom:(NSDictionary *)commentDict {
  PFMComment * comment = [PFMComment new];

  comment.oid        = [commentDict objectOrNilForKey:@"id"];
  comment.userId     = [commentDict objectOrNilForKey:@"user_id"];
  comment.locationId = [commentDict objectOrNilForKey:@"location_id"];
  comment.body       = [commentDict objectOrNilForKey:@"body"];
  comment.momentId   = [commentDict objectOrNilForKey:@"moment_id"];
  comment.userId     = [commentDict objectOrNilForKey:@"user_id"];
  comment.state      = [commentDict objectOrNilForKey:@"state"];
  comment.createdAt  = [NSDate dateWithTimeIntervalSince1970:floor([[commentDict objectOrNilForKey:@"created"] doubleValue])];

  return comment;
}

- (NSDictionary *) toHash {
  NSMutableDictionary *commentDict =  $mdict(self.oid, @"id",
                                            self.body, @"body",
                                           self.state, @"state");

  if(self.locationId != nil) {
    PFMLocation * location = [[NSApp sharedLocations] objectForKey:self.locationId];
    if(location != nil) {
      [commentDict setObject:[location toHash] forKey:@"location"];
    }
  }

  if(self.userId != nil) {
    PFMUser * user = [[NSApp sharedUsers] objectForKey:self.userId];
    if(user != nil) {
      [commentDict setObject:[user toHash] forKey:@"user"];
    }
  }

  [commentDict setObjectOrNil:[self.createdAt descriptionInISO8601] forKey:@"createdAt"];

  return commentDict;
}

- (NSString *) JSONRepresentation {
  return [[self toHash] JSONRepresentation];
}

@end
