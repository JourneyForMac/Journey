#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "PFMUser.h"

@interface PFMMainWindowController : NSWindowController

@property (nonatomic, retain) IBOutlet WebView *webView;

@end
