#import <Cocoa/Cocoa.h>

@class PFMUser;

@interface NSApplication (SharedObjects)

- (PFMUser *)sharedUser;
- (NSMutableDictionary *)sharedLocations;
- (NSMutableDictionary *)sharedPlaces;

- (PFMUser *)resetSharedUser;
- (NSMutableDictionary *)resetSharedLocations;
- (NSMutableDictionary *)resetSharedPlaces;

@end
