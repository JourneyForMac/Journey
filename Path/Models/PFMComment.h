#import <Foundation/Foundation.h>

@interface PFMComment : NSObject

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * locationId;
@property (nonatomic, copy) NSString * momentId;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * body;
@property (nonatomic, retain) NSDate * createdAt;

+ (PFMComment *)commentFrom:(NSDictionary *)commentDict;

- (NSString *) JSONRepresentation;
- (NSDictionary *) toHash;

@end
