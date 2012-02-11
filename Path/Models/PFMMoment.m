#import "PFMMoment.h"
#import "PFMPhoto.h"
#import "PFMComment.h"
#import "Application.h"

@implementation PFMMoment

@synthesize
  id = _id
, userId = _userId
, locationId = _locationId
, type = _type
, headline = _headline
, subHeadline = _subHeadline
, thought = _thought
, state = _state
, createdAt = _createdAt
, shared = _shared
, private = _private
, photo=_photo
, comments=_comments
;

+ (PFMMoment *)momentFrom:(NSDictionary *)rawMoment {
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

  if($eql(moment.type, @"photo")) {
    NSDictionary * photoDictionary = (NSDictionary *)[(NSDictionary *)[rawMoment $for:@"photo"] $for:@"photo"];
    moment.photo = [PFMPhoto photoFrom:photoDictionary];
  }

  moment.comments = $marr(nil);

  for(NSDictionary * commentDict in (NSArray *)[rawMoment $for:@"comments"]) {
    PFMComment * comment = [PFMComment commentFrom:commentDict];
    [moment.comments addObject:comment];
  }

  return moment;
}


@end
