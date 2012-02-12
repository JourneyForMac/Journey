#import "NSDictionary+PFMAdditions.h"

@implementation NSDictionary (PFMAdditions)

- (id)objectOrNilForKey:(id)key {
  id object = [self objectForKey:key];
  if(object == [NSNull null]) {
    return nil;
  }
  return object;
}

@end
