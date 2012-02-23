#import "NSMutableDictionary+PFMAdditions.h"

@implementation NSMutableDictionary (PFMAdditions)

- (void)setObjectOrNil:(id)object forKey:(id)key {
  if(!object) {
    [self removeObjectForKey:key];
    return;
  }
  [self setObject:object forKey:key];
}

@end
