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

  place.id   = [placeDict objectOrNilForKey:@"id"];
  place.name = [placeDict objectOrNilForKey:@"name"];

  NSDictionary * locationDict = [placeDict objectOrNilForKey:@"location"];
  NSDictionary * contactDict  = [placeDict objectOrNilForKey:@"contact"];

  if(locationDict != nil) {
    place.city       = [locationDict objectOrNilForKey:@"city"];
    place.country    = [locationDict objectOrNilForKey:@"country"];
    place.address    = [locationDict objectOrNilForKey:@"address"];
    place.postalCode = [locationDict objectOrNilForKey:@"postalCode"];
    place.state      = [locationDict objectOrNilForKey:@"state"];

    place.latitude   = [(NSNumber *)[locationDict objectOrNilForKey:@"lat"] doubleValue];
    place.longitude  = [(NSNumber *)[locationDict objectOrNilForKey:@"lng"] doubleValue];
  }

  if(contactDict != nil) {
    place.phone          = [contactDict objectOrNilForKey:@"phone"];
    place.formattedPhone = [contactDict objectOrNilForKey:@"formattedPhone"];
  }

  place.totalCheckins = [(NSNumber *)[placeDict objectOrNilForKey:@"total_checkins"] intValue];


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
