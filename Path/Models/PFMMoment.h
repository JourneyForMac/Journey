#import <Foundation/Foundation.h>
#import "PFMModel.h"

@interface PFMMoment : PFMModel

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * locationId;

@property (nonatomic, copy) NSString * type;

@property (nonatomic, copy) NSString * headline;
@property (nonatomic, copy) NSString * subHeadline;
@property (nonatomic, copy) NSString * thought;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, retain) NSDate * createdAt;

@property (nonatomic, getter=isShared) BOOL shared;
@property (nonatomic, getter=isPrivate) BOOL private;

// There are other components (which may or may not be self-standing objects)
// photo
// location
// emotions
// comments
// place
// origin_location
// destination_location

@end
