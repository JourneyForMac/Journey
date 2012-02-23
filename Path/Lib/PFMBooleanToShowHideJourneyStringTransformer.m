#import "PFMBooleanToShowHideJourneyStringTransformer.h"

@implementation PFMBooleanToShowHideJourneyStringTransformer

+ (Class)transformedValueClass {
  return [NSString class];
}
+ (BOOL)allowsReverseTransformation {
  return NO;
}
- (id)transformedValue:(id)value {
	if(value && ![value boolValue]) {
    return @"Show Journey";
	}
  return @"Hide Journey";
}

@end
