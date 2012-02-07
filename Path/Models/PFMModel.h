#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface PFMModel : NSObject

@property (nonatomic, copy) NSString *url;

- (ASIHTTPRequest *)requestWithPath:(NSString *)path;

@end
