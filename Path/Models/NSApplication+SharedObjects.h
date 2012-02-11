#import <Cocoa/Cocoa.h>

@class PFMUser;

@interface NSApplication (SharedObjects)

- (PFMUser *)sharedUser;
- (PFMUser *)resetSharedUser;

@end
