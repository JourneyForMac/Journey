#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "PFMUser.h"

@interface PFMMomentListViewController : NSViewController <
  PFMUserMomentsDelegate
>

@property (nonatomic, retain) IBOutlet WebView *webView;

- (void)refreshFeed;
- (void)loadOldMoments;
- (NSInteger)webViewScrollTop;

@end
