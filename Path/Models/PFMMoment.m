#import "PFMMoment.h"
#import "PFMPhoto.h"
#import "PFMComment.h"
#import "PFMLocation.h"
#import "Application.h"
#import "PFMPlace.h"
#import "SBJson.h"

@implementation PFMMoment

@synthesize
  id = _id
, userId = _userId
, placeId=_placeId
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

  moment.id          = [rawMoment objectOrNilForKey:@"id"];
  moment.locationId  = [rawMoment objectOrNilForKey:@"location_id"];
  moment.userId      = [rawMoment objectOrNilForKey:@"user_id"];

  moment.type        = [rawMoment objectOrNilForKey:@"type"];
  moment.headline    = [rawMoment objectOrNilForKey:@"headline"];
  moment.subHeadline = [rawMoment objectOrNilForKey:@"subheadline"];
  moment.thought     = [rawMoment objectOrNilForKey:@"thought"];
  moment.state       = [rawMoment objectOrNilForKey:@"state"];
  moment.createdAt   = [NSDate dateWithTimeIntervalSince1970:floor([[rawMoment objectOrNilForKey:@"created"] doubleValue])];
  moment.private     = [(NSNumber *)[rawMoment objectOrNilForKey:@"private"] boolValue];
  moment.shared      = [(NSNumber *)[rawMoment objectOrNilForKey:@"shared"] boolValue];

  NSDictionary * place = [rawMoment objectOrNilForKey:@"place"];
  moment.placeId       = [place objectOrNilForKey:@"id"];

  if($eql(moment.type, @"photo")) {
    NSDictionary * photoDictionary = (NSDictionary *)[(NSDictionary *)[rawMoment objectOrNilForKey:@"photo"] objectOrNilForKey:@"photo"];
    moment.photo = [PFMPhoto photoFrom:photoDictionary];
  }

  moment.comments = $marr(nil);

  for(NSDictionary * commentDict in (NSArray *)[rawMoment objectOrNilForKey:@"comments"]) {
    PFMComment * comment = [PFMComment commentFrom:commentDict];
    [moment.comments addObject:comment];
  }

  return moment;
}

- (NSDictionary *) toHash {
  NSMutableDictionary * momentDict = $mdict(self.id, @"id",
                                          self.type, @"type");

  [momentDict setObjectOrNil:self.headline       forKey:@"headline"];
  [momentDict setObjectOrNil:self.subHeadline    forKey:@"subHeadline"];
  [momentDict setObjectOrNil:self.thought        forKey:@"thought"];
  [momentDict setObjectOrNil:self.state          forKey:@"state"];
  [momentDict setObjectOrNil:[self.photo toHash] forKey:@"photo"];
  [momentDict setObjectOrNil:$bool(self.shared)  forKey:@"shared"];
  [momentDict setObjectOrNil:$bool(self.private) forKey:@"private"];

  if(self.locationId != nil) {
    PFMLocation * location = [[NSApp sharedLocations] objectForKey:self.locationId];
    [momentDict setObjectOrNil:[location toHash] forKey:@"location"];
  }

  if(self.placeId != nil) {
    PFMPlace * place = [[NSApp sharedPlaces] objectForKey:self.placeId];
    [momentDict setObjectOrNil:[place toHash] forKey:@"place"];
  }

  if(self.userId != nil) {
    PFMUser * user = [[NSApp sharedUsers] objectForKey:self.userId];
    [momentDict setObjectOrNil:[user toHash] forKey:@"user"];
  }

  [momentDict setObjectOrNil:[self.createdAt descriptionInISO8601] forKey:@"createdAt"];

  NSArray * commentsDictionaryArray = [self.comments $map:^(id obj) {
                                        return [(PFMComment *)obj toHash];
                                      }];
  [momentDict setObject:commentsDictionaryArray forKey:@"comments"];

  return momentDict;
}

- (NSString *) JSONRepresentation {
  return [[self toHash] JSONRepresentation];
}

@end
