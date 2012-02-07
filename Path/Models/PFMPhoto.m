#import "PFMPhoto.h"

@implementation PFMPhoto

@synthesize
  iOSLowResFileName = _iOSLowResFileName
, iOSHighResFileName = _iOSHighResFileName
, webFileName = _webFileName
, originalFileName = _originalFileName
, baseURL = _baseURL;

- (NSString *) iOSLowResURL {
  return [NSString stringWithFormat:@"%@/%@", self.baseURL, self.iOSLowResFileName];
}

- (NSString *) iOSHighResURL {
  return [NSString stringWithFormat:@"%@/%@", self.baseURL, self.iOSHighResFileName];
}

- (NSString *) webURL {
  return [NSString stringWithFormat:@"%@/%@", self.baseURL, self.webFileName];
}

- (NSString *) originalURL {
  return [NSString stringWithFormat:@"%@/%@", self.baseURL, self.originalFileName];
}


@end
