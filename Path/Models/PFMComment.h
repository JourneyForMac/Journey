#import <Foundation/Foundation.h>

@interface PFMComment : NSObject {
  NSString *_oid;
  NSString *_locationId;
  NSString *_momentId;
  NSString *_userId;
  NSString *_state;
  NSString *_body;
  NSDate *_createdAt;
}

@property (nonatomic, copy) NSString *oid;
@property (nonatomic, copy) NSString *locationId;
@property (nonatomic, copy) NSString *momentId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, retain) NSDate *createdAt;

+ (PFMComment *)commentFrom:(NSDictionary *)commentDict;

- (NSString *)JSONRepresentation;
- (NSDictionary *)toHash;

@end
