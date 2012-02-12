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
  if(!self.iOSLowResFileName) {
    return nil;
  }
  return [NSString stringWithFormat:@"%@/%@", self.baseURL, self.iOSLowResFileName];
}

- (NSString *) iOSHighResURL {
  if(!self.iOSHighResFileName) {
    return nil;
  }
  return [NSString stringWithFormat:@"%@/%@", self.baseURL, self.iOSHighResFileName];
}

- (NSString *) webURL {
  if(!self.webFileName) {
    return nil;
  }
  return [NSString stringWithFormat:@"%@/%@", self.baseURL, self.webFileName];
}

- (NSString *) originalURL {
  if(!self.originalFileName) {
    return nil;
  }
  return [NSString stringWithFormat:@"%@/%@", self.baseURL, self.originalFileName];
}

- (NSDictionary *) toHash {
  NSMutableDictionary *dict = $mdict(nil);

  [dict setObjectOrNil:[self iOSLowResURL]  forKey:@"iOSLowResURL"];
  [dict setObjectOrNil:[self iOSHighResURL] forKey:@"iOSHighResURL"];
  [dict setObjectOrNil:[self webURL]        forKey:@"webURL"];
  [dict setObjectOrNil:[self originalURL]   forKey:@"originalURL"];

  return dict;
}

- (NSString *) JSONRepresentation {
  return [[self toHash] JSONRepresentation];
}

@end
