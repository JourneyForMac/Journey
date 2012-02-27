#import "ASIHTTPRequest.h"

@interface ASIHTTPRequest (Spec)

+ (NSMutableArray *)requests;
+ (void)resetRequests;
+ (ASIHTTPRequest *)mostRecentRequest;

- (ASIBasicBlock)startedBlock;
- (ASIBasicBlock)completionBlock;
- (ASIBasicBlock)failureBlock;
- (void)startSynchronous2;
- (void)startAsynchronous2;

@property (getter=isStarted) BOOL started;
@property (getter=isAsynchronous) BOOL asynchronous;

@end
