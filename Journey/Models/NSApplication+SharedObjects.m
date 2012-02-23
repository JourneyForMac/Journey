#import "NSApplication+SharedObjects.h"
#import "PFMUser.h"
#import "Application.h"

static PFMUser *_sharedUser = nil;
static NSMutableDictionary *_sharedLocations = nil;
static NSMutableDictionary *_sharedPlaces = nil;
static NSMutableDictionary *_sharedUsers = nil;
@implementation NSApplication (SharedObjects)

- (PFMUser *)sharedUser {
  @synchronized(self) {
    if(!_sharedUser) {
      _sharedUser = [PFMUser new];
    }
  }
  return _sharedUser;
}

- (NSMutableDictionary *)sharedLocations {
  @synchronized(self) {
    if(!_sharedLocations) {
      _sharedLocations = $mdict(nil);
    }
  }
  return _sharedLocations;
}

- (NSMutableDictionary *)sharedUsers {
  @synchronized(self) {
    if(!_sharedUsers) {
      _sharedUsers = $mdict(nil);
    }

    return _sharedUsers;
  }
}

- (NSMutableDictionary *)sharedPlaces {
  @synchronized(self) {
    if(!_sharedPlaces) {
      _sharedPlaces = $mdict(nil);
    }
  }
  return _sharedPlaces;
}

- (PFMUser *)resetSharedUser {
  _sharedUser = nil;
  return [self sharedUser];
}

- (NSMutableDictionary *)resetSharedLocations {
  _sharedLocations = nil;
  return [self sharedLocations];
}

- (NSMutableDictionary *)resetSharedPlaces {
  _sharedPlaces = nil;
  return [self sharedPlaces];
}

- (NSMutableDictionary *)resetSharedUsers {
  _sharedUsers = nil;
  return [self sharedUsers];
}


@end
