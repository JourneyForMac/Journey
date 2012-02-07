#import "TestHelper.h"
#import "ASIHTTPRequest+Spec.h"
#import <objc/runtime.h>

@implementation ASIHTTPRequest (Spec)

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
}

- (void)startAsynchronous {
  self.started = YES;
  self.asynchronous = YES;
}

@end
