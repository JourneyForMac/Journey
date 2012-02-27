#import <WebKit/WebKit.h>

@interface WebView (Spec)

+ (NSMutableArray *)javascripts;
+ (void)setJavascriptReturnValue:(NSString *)returnValue;
+ (NSString *)javascriptReturnValue;
+ (void)resetJavascripts;

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;

@end
