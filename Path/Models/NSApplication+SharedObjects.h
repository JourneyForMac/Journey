#import <Cocoa/Cocoa.h>

@class PFMUser;

@interface NSApplication (SharedObjects)

- (PFMUser *)sharedUser;
- (NSMutableDictionary *)sharedLocations;
- (NSMutableDictionary *)sharedPlaces;
- (NSMutableDictionary *)sharedUsers;

- (PFMUser *)resetSharedUser;
- (NSMutableDictionary *)resetSharedLocations;
- (NSMutableDictionary *)resetSharedPlaces;
- (NSMutableDictionary *)resetSharedUsers;

@end
