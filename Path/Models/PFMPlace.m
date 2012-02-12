#import "PFMPlace.h"
#import "Application.h"
#import "SBJson.h"

@implementation PFMPlace

@synthesize
  id=_id
, name=_name
, city=_city
, country=_country
, state=_state
, postalCode=_postalCode
, address=_address
, latitude=_latitude
, longitude=_longitude
, totalCheckins=_totalCheckins
, phone=_phone
, formattedPhone=_formattedPhone;

+ (PFMPlace *)placeFrom:(NSDictionary *)placeDict {
  PFMPlace * place = [PFMPlace new];

  place.id = $safe([placeDict $for:@"id"]);
  place.name = $safe([placeDict $for:@"name"]);

  NSDictionary * locationDict = $safe([placeDict $for:@"location"]);
  NSDictionary * contactDict = $safe([placeDict $for:@"contact"]);

  if(locationDict != nil) {
    place.city = $safe([locationDict $for:@"city"]);
    place.country = $safe([locationDict $for:@"country"]);
    place.address = $safe([locationDict $for:@"address"]);
    place.postalCode = $safe([locationDict $for:@"postalCode"]);
    place.state = $safe([locationDict $for:@"state"]);

    place.latitude = [(NSNumber *)$safe([locationDict $for:@"lat"]) doubleValue];
    place.longitude = [(NSNumber *)$safe([locationDict $for:@"lng"]) doubleValue];
  }

  if(contactDict != nil) {
    place.phone = $safe([contactDict $for:@"phone"]);
    place.formattedPhone = $safe([contactDict $for:@"formattedPhone"]);
  }

  place.totalCheckins = [(NSNumber *)$safe([placeDict $for:@"total_checkins"]) intValue];


  return place;
}

- (NSDictionary *) toHash {
  NSMutableDictionary * placeDict = $mdict(self.id, @"id",
                            $double(self.latitude), @"latitude",
                           $double(self.longitude), @"longitude",
                      $integer(self.totalCheckins), @"totalCheckins");

  [placeDict setObjectOrNil:self.name           forKey:@"name"];
  [placeDict setObjectOrNil:self.address        forKey:@"address"];
  [placeDict setObjectOrNil:self.city           forKey:@"city"];
  [placeDict setObjectOrNil:self.country        forKey:@"country"];
  [placeDict setObjectOrNil:self.state          forKey:@"state"];
  [placeDict setObjectOrNil:self.postalCode     forKey:@"postalCode"];
  [placeDict setObjectOrNil:self.phone          forKey:@"phone"];
  [placeDict setObjectOrNil:self.formattedPhone forKey:@"formattedPhone"];


  return (NSDictionary *)placeDict;
}

- (NSString *) JSONRepresentation {
  return [[self toHash] JSONRepresentation];
}

@end
