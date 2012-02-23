#import <Foundation/Foundation.h>

@interface PFMPlace : NSObject {
  NSString *_oid;
  NSString *_name;
  NSString *_address;
  NSString *_city;
  NSString *_country;
  NSString *_state;
  NSString *_postalCode;

  double _latitude;
  double _longitude;

  NSUInteger _totalCheckins;

  NSString *_phone;
  NSString *_formattedPhone;
}

@property(nonatomic, copy) NSString *oid;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, copy) NSString *state;
@property(nonatomic, copy) NSString *postalCode;

@property(nonatomic) double latitude;
@property(nonatomic) double longitude;

@property(nonatomic) NSUInteger totalCheckins;

@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *formattedPhone;

+ (PFMPlace *)placeFrom:(NSDictionary *)placeDict;

- (NSDictionary *)toHash;
- (NSString *)JSONRepresentation;

@end
