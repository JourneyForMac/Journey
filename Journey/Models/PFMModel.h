#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface PFMModel : NSObject {
  NSString *_url;
}

@property (nonatomic, copy) NSString *url;

- (ASIHTTPRequest *)requestWithPath:(NSString *)path;

@end
