#import "TestHelper.h"
#import "WebView+Spec.h"
#import "ConciseKit.h"

static NSMutableArray *javascripts = nil;
static NSString *javascriptReturnValue = nil;

@implementation WebView (Spec)

+ (void)initialize {
  [super initialize];
  [$ swizzleMethod:@selector(stringByEvaluatingJavaScriptFromString:) with:@selector(stringByEvaluatingJavaScriptFromString2:) in:[self class]];
}

+ (NSMutableArray *)javascripts {
  @synchronized(self) {
    if(!javascripts) {
      javascripts = [NSMutableArray new];
    }
  }
  return javascripts;
}

+ (void)stubJavascriptReturnValue:(NSString *)returnValue {
  javascriptReturnValue = returnValue;
}

+ (void)resetJavascripts {
  [[self javascripts] removeAllObjects];
  javascriptReturnValue = nil;
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script {
  [[[self class] javascripts] addObject:script];
  return javascriptReturnValue;
}

@end
