//
//  PFMLocation.h
//  Path for Mac
//
//  Created by Arun Thampi on 11/2/12.
//  Copyright (c) 2012 DecisiveBits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFMLocation : NSObject

@property(nonatomic, copy) NSString * id;
@property(nonatomic, copy) NSString * weatherConditions;
@property(nonatomic, copy) NSString * cloudCover;
@property(nonatomic, copy) NSString * windSpeed;
@property(nonatomic, copy) NSString * dewPoint;
@property(nonatomic, copy) NSString * temperature;
@property(nonatomic, copy) NSString * windDirection;

@property(nonatomic, assign) double elevation;
@property(nonatomic, assign) double longitude;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double accuracy;

@property(nonatomic, copy) NSString * countryName;
@property(nonatomic, copy) NSString * country;
@property(nonatomic, copy) NSString * city;

+ (PFMLocation *)locationFrom:(NSDictionary *)locationDict;

- (NSDictionary *)toHash;
- (NSString *) JSONRepresentation;

@end
