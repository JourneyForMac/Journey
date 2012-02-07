#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "PFMUser.h"

@interface PFMActivityWindowController : NSWindowController

@property (nonatomic, retain) IBOutlet WebView *webView;

@end
