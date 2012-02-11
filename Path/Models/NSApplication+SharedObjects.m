#import "NSApplication+SharedObjects.h"
#import "PFMUser.h"

static PFMUser *_sharedUser = nil;

@implementation NSApplication (SharedObjects)

- (PFMUser *)sharedUser {
  @synchronized(self) {
    if(!_sharedUser) {
      _sharedUser = [PFMUser new];
    }
    return _sharedUser;
  }
}

@end
