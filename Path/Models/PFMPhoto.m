#import "PFMPhoto.h"
#import "Application.h"

@implementation PFMPhoto

@synthesize
  iOSLowResFileName = _iOSLowResFileName
, iOSHighResFileName = _iOSHighResFileName
, webFileName = _webFileName
, originalFileName = _originalFileName
, baseURL = _baseURL;

+ (PFMPhoto *)photoFrom:(NSDictionary *)photoDict {
  PFMPhoto * photo = [PFMPhoto new];
  photo.baseURL = $safe([photoDict $for:@"url"]);
  NSDictionary * iOSDetails = (NSDictionary *)[photoDict $for:@"ios"];
  
  photo.iOSHighResFileName = [(NSDictionary *)[iOSDetails $for:@"2x"] $for:@"file"];
  photo.iOSLowResFileName = [(NSDictionary *)[iOSDetails $for:@"1x"] $for:@"file"];
  photo.webFileName = [(NSDictionary *)[photoDict $for:@"web"] $for:@"file"];
  photo.originalFileName = [(NSDictionary *)[photoDict $for:@"original"] $for:@"file"];
  
  return photo;
}

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
