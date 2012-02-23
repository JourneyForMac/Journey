#import "NSWindow+PFMAdditions.h"

@implementation NSWindow (PFMAdditions)

- (void)focus {
  [self makeKeyAndOrderFront:nil];
  [NSApp activateIgnoringOtherApps:YES];
}

@end
