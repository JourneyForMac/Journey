#import "TestHelper.h"
#import "ASIHTTPRequest+Spec.h"
#import <objc/runtime.h>

static NSMutableArray *requests = nil;

@implementation ASIHTTPRequest (Spec)

+ (NSMutableArray *)requests {
  @synchronized(self) {
    if(!requests) {
      requests = [NSMutableArray new];
    }
  }
  return requests;
}

+ (void)resetRequests {
  [[self requests] removeAllObjects];
}

+ (ASIHTTPRequest *)mostRecentRequest {
  return [[self requests] lastObject];
}

- (ASIBasicBlock)startedBlock {
  return startedBlock;
}

- (ASIBasicBlock)completionBlock {
  return completionBlock;
}

- (ASIBasicBlock)failureBlock {
  return failureBlock;
}

- (void)setStarted:(BOOL)started {
  objc_setAssociatedObject(self, "started", $bool(started), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isStarted {
  return [objc_getAssociatedObject(self, "started") boolValue];
}

- (void)setAsynchronous:(BOOL)asynchronous {
  objc_setAssociatedObject(self, "asynchronous", $bool(asynchronous), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAsynchronous {
  return [objc_getAssociatedObject(self, "asynchronous") boolValue];
}

#pragma mark - stubbed methods

- (void)startSynchronous {
  self.started = YES;
  self.asynchronous = NO;
  [[[self class] requests] addObject:self];
}

- (void)startAsynchronous {
  self.started = YES;
  self.asynchronous = YES;
  [[[self class] requests] addObject:self];
}

- (void)start {
  self.started = YES;
  [[[self class] requests] addObject:self];
}

@end
