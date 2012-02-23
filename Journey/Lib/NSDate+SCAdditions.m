#import "NSDate+SCAdditions.h"

@implementation NSDate (SCAdditions)

- (NSString *)descriptionInISO8601 {
  return [self descriptionWithCalendarFormat:@"%Y-%m-%dT%H:%M:%SZ" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0] locale:nil];
}

@end
