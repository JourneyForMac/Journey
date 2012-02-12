#import "PFMComment.h"
#import "Application.h"
#import "SBJson.h"

@implementation PFMComment

@synthesize
  id=_id
, userId=_userId
, locationId=_locationId
, momentId=_momentId
, body=_body
, state=_state
, createdAt=_createdAt;

+ (PFMComment *)commentFrom:(NSDictionary *)commentDict {
  PFMComment * comment = [PFMComment new];

  comment.id = $safe([commentDict $for:@"id"]);
  comment.userId = $safe([commentDict $for:@"user_id"]);
  comment.locationId = $safe([commentDict $for:@"location_id"]);
  comment.body = $safe([commentDict $for:@"body"]);
  comment.momentId = $safe([commentDict $for:@"moment_id"]);
  comment.userId = $safe([commentDict $for:@"user_id"]);
  comment.state = $safe([commentDict $for:@"state"]);
  comment.createdAt = [NSDate dateWithTimeIntervalSince1970:floor([$safe([commentDict $for:@"created"]) doubleValue])];

  return comment;
}

- (NSDictionary *) toHash {
  return $dict(self.id, @"id",
               self.body, @"body",
               self.state, @"state");
}

- (NSString *) JSONRepresentation {
  return [[self toHash] JSONRepresentation];
}

@end
