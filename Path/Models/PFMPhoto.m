#import "PFMPhoto.h"
#import "Application.h"
#import "SBJson.h"

@implementation PFMPhoto

@synthesize
  iOSLowResFileName = _iOSLowResFileName
, iOSHighResFileName = _iOSHighResFileName
, webFileName = _webFileName
, originalFileName = _originalFileName
, baseURL = _baseURL;

+ (PFMPhoto *)photoFrom:(NSDictionary *)photoDict {
  PFMPhoto * photo = [PFMPhoto new];
  photo.baseURL             = [photoDict objectOrNilForKey:@"url"];
  NSDictionary * iOSDetails = (NSDictionary *)[photoDict objectOrNilForKey:@"ios"];

  photo.iOSHighResFileName  = [(NSDictionary *)[iOSDetails objectOrNilForKey:@"2x"] objectOrNilForKey:@"file"];
  photo.iOSLowResFileName   = [(NSDictionary *)[iOSDetails objectOrNilForKey:@"1x"] objectOrNilForKey:@"file"];
  photo.webFileName         = [(NSDictionary *)[photoDict objectOrNilForKey:@"web"] objectOrNilForKey:@"file"];
  photo.originalFileName    = [(NSDictionary *)[photoDict objectOrNilForKey:@"original"] objectOrNilForKey:@"file"];

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

- (NSDictionary *) toHash {
  return $dict([self iOSLowResURL], @"iOSLowResURL",
               [self iOSHighResURL], @"iOSHighResURL",
               [self webURL], @"webURL",
               [self originalURL], @"originalURL");
}

- (NSString *) JSONRepresentation {
  return [[self toHash] JSONRepresentation];
}

@end
