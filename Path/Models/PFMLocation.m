#import "PFMLocation.h"
#import "Application.h"
#import "SBJson.h"

@implementation PFMLocation

@synthesize
  id=_id
, weatherConditions=_weatherConditions
, cloudCover=_cloudCover
, windSpeed=_windSpeed
, dewPoint=_dewPoint
, temperature=_temperature
, windDirection=_windDirection
, elevation=_elevation
, longitude=_longitude
, latitude=_latitude
, accuracy=_accuracy
, countryName=_countryName
, country=_country
, city=_city;

+ (PFMLocation *)locationFrom:(NSDictionary *)locationDict {
  PFMLocation * location = [PFMLocation new];

  NSDictionary * weatherDict         = (NSDictionary *)[locationDict objectOrNilForKey:@"weather"];
  NSDictionary * locationDetailsDict = (NSDictionary *)[locationDict objectOrNilForKey:@"location"];

  location.id = [locationDict objectOrNilForKey:@"id"];

  if (weatherDict != nil) {
    location.weatherConditions = [weatherDict objectOrNilForKey:@"conditions"];
    location.cloudCover        = [weatherDict objectOrNilForKey:@"cloud_cover"];
    location.windSpeed         = [weatherDict objectOrNilForKey:@"wind_speed"];
    location.windDirection     = [weatherDict objectOrNilForKey:@"wind_direction"];
    location.dewPoint          = [weatherDict objectOrNilForKey:@"dewpoint"];
    location.temperature       = [weatherDict objectOrNilForKey:@"temperature"];
  }

  if (location != nil) {
    location.elevation   = [(NSNumber *)[locationDetailsDict objectOrNilForKey:@"elevation"] doubleValue];
    location.accuracy    = [(NSNumber *)[locationDetailsDict objectOrNilForKey:@"accuracy"] doubleValue];
    location.countryName = [locationDetailsDict objectOrNilForKey:@"country_name"];
    location.country     = [locationDetailsDict objectOrNilForKey:@"country"];
    location.city        = [locationDetailsDict objectOrNilForKey:@"city"];
  }

  location.latitude  = [(NSNumber *)[locationDict objectOrNilForKey:@"lat"] doubleValue];
  location.longitude = [(NSNumber *)[locationDict objectOrNilForKey:@"lng"] doubleValue];

  return location;
}

- (NSDictionary *) toHash {
  NSMutableDictionary * locationDict = $mdict(self.id, @"id",
                              $double(self.elevation), @"elevation",
                               $double(self.latitude), @"latitude",
                              $double(self.longitude), @"longitude",
                               $double(self.accuracy), @"accuracy");

  [locationDict setObjectOrNil:self.weatherConditions forKey:@"weatherConditions"];
  [locationDict setObjectOrNil:self.cloudCover        forKey:@"cloudCover"];
  [locationDict setObjectOrNil:self.windSpeed         forKey:@"windSpeed"];
  [locationDict setObjectOrNil:self.dewPoint          forKey:@"dewPoint"];
  [locationDict setObjectOrNil:self.temperature       forKey:@"temperature"];
  [locationDict setObjectOrNil:self.windDirection     forKey:@"windDirection"];
  [locationDict setObjectOrNil:self.countryName       forKey:@"countryName"];
  [locationDict setObjectOrNil:self.country           forKey:@"country"];
  [locationDict setObjectOrNil:self.city              forKey:@"city"];

  return (NSDictionary *)locationDict;
}

- (NSString *) JSONRepresentation {
  return [[self toHash] JSONRepresentation];
}

@end
