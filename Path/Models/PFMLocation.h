#import <Foundation/Foundation.h>

@interface PFMLocation : NSObject {
  NSString *_oid;
  NSString *_weatherConditions;
  NSString *_cloudCover;
  NSString *_windSpeed;
  NSString *_dewPoint;
  NSString *_temperature;
  NSString *_windDirection;

  double _elevation;
  double _longitude;
  double _latitude;
  double _accuracy;

  NSString *_countryName;
  NSString *_country;
  NSString *_city;
}

@property(nonatomic, copy) NSString *oid;
@property(nonatomic, copy) NSString *weatherConditions;
@property(nonatomic, copy) NSString *cloudCover;
@property(nonatomic, copy) NSString *windSpeed;
@property(nonatomic, copy) NSString *dewPoint;
@property(nonatomic, copy) NSString *temperature;
@property(nonatomic, copy) NSString *windDirection;

@property(nonatomic) double elevation;
@property(nonatomic) double longitude;
@property(nonatomic) double latitude;
@property(nonatomic) double accuracy;

@property(nonatomic, copy) NSString *countryName;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, copy) NSString *city;

+ (PFMLocation *)locationFrom:(NSDictionary *)locationDict;

- (NSDictionary *)toHash;
- (NSString *)JSONRepresentation;

@end
