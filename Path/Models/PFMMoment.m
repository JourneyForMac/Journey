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

  NSDictionary * place = $safe([rawMoment $for:@"place"]);

  if (place != nil) {
    moment.placeId = $safe([place $for:@"id"]);
  }

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

- (NSDictionary *) toHash {
  NSMutableDictionary * momentDict = $mdict(self.id, @"id",
                                            self.type, @"type");

  [momentDict setObject:((self.headline == nil) ? [NSNull null] : self.headline)
                   forKey:@"headline"];
  [momentDict setObject:((self.subHeadline == nil) ? [NSNull null] : self.subHeadline)
                 forKey:@"subHeadline"];
  [momentDict setObject:((self.thought == nil) ? [NSNull null] : self.thought)
                 forKey:@"thought"];
  [momentDict setObject:((self.state == nil) ? [NSNull null] : self.state)
                 forKey:@"state"];
  [momentDict setObject:((self.photo == nil) ? [NSNull null] : [self.photo toHash])
                 forKey:@"photo"];
  [momentDict setObject:$bool(self.shared) forKey:@"shared"];
  [momentDict setObject:$bool(self.private) forKey:@"private"];

  if(self.locationId != nil) {
    PFMLocation * location = [[NSApp sharedLocations] objectForKey:self.locationId];
    if(location != nil) {
      [momentDict setObject:[location toHash] forKey:@"location"];
    }
  }

  if(self.placeId != nil) {
    PFMPlace * place = [[NSApp sharedPlaces] objectForKey:self.placeId];
    if(place != nil) {
      [momentDict setObject:[place toHash] forKey:@"place"];
    }
  }

  if(self.userId != nil) {
    PFMUser * user = [[NSApp sharedUsers] objectForKey:self.userId];
    if(user != nil) {
      [momentDict setObject:[user toHash] forKey:@"user"];
    }
  }

  if(self.createdAt != nil) {
    NSNumber * created = $double([self.createdAt timeIntervalSince1970]);
    [momentDict setObject:created forKey:@"createdAt"];
  }

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
