#import <Foundation/Foundation.h>

@interface PFMPlace : NSObject

@property(nonatomic, copy) NSString * oid;
@property(nonatomic, copy) NSString * name;
@property(nonatomic, copy) NSString * address;
@property(nonatomic, copy) NSString * city;
@property(nonatomic, copy) NSString * country;
@property(nonatomic, copy) NSString * state;
@property(nonatomic, copy) NSString * postalCode;

@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;

@property(nonatomic, assign) NSUInteger totalCheckins;

@property(nonatomic, copy) NSString * phone;
@property(nonatomic, copy) NSString * formattedPhone;

+ (PFMPlace *)placeFrom:(NSDictionary *)placeDict;

- (NSDictionary *) toHash;
- (NSString *) JSONRepresentation;

@end
