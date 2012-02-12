#import <Foundation/Foundation.h>

@interface PFMPhoto : NSObject

// Low-Res version 320x320
@property (nonatomic, copy) NSString * iOSLowResFileName;
// High-Res version 640x640
@property (nonatomic, copy) NSString * iOSHighResFileName;
// Web version (which will be kinda blurred)
@property (nonatomic, copy) NSString * webFileName;
// Original version (super high-res)
@property (nonatomic, copy) NSString * originalFileName;
// Base URL
@property (nonatomic, copy) NSString * baseURL;

+ (PFMPhoto *) photoFrom:(NSDictionary *)photoDict;

- (NSString *) iOSLowResURL;
- (NSString *) iOSHighResURL;
- (NSString *) webURL;
- (NSString *) originalURL;

- (NSString *) JSONRepresentation;
- (NSDictionary *) toHash;

@end
