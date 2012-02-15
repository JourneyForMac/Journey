#import <Foundation/Foundation.h>
#import "PFMModel.h"

@class PFMPhoto;

@interface PFMMoment : PFMModel

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * locationId;
@property (nonatomic, copy) NSString * placeId;

@property (nonatomic, copy) NSString * type;

@property (nonatomic, copy) NSString * headline;
@property (nonatomic, copy) NSString * subHeadline;
@property (nonatomic, copy) NSString * thought;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, assign) double createdAt;
@property (nonatomic, retain) PFMPhoto * photo;

@property (nonatomic, retain) NSMutableArray * comments;

@property (nonatomic, getter=isShared) BOOL shared;
@property (nonatomic, getter=isPrivate) BOOL private;

// There are other components (which may or may not be self-standing objects)
// emotions
// origin_location
// destination_location

+ (PFMMoment *)momentFrom:(NSDictionary *)rawMoment;

- (NSDictionary *) toHash;
- (NSString *) JSONRepresentation;

@end
