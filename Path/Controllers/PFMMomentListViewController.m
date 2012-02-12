#import "PFMMomentListViewController.h"
#import "Application.h"
#import "SBJson.h"
#import "PFMMoment.h"
#import "PFMUser.h"
#import "PFMPhoto.h"

@implementation PFMMomentListViewController

@synthesize
  webView=_webView
;

- (id)init {
  self = [super initWithNibName:@"MomentListView" bundle:nil];
  return self;
}

- (void)loadView {
  [super loadView];

  NSString *webViewPath = [[$ resourcePath] $append:@"/WebView/"];
  NSString *html = [NSString stringWithContentsOfFile:[webViewPath $append:@"index.html"] encoding:NSUTF8StringEncoding error:NULL];
  [[self.webView mainFrame] loadHTMLString:html baseURL:[NSURL fileURLWithPath:webViewPath]];

  PFMUser *user = [NSApp sharedUser];
  user.momentsDelegate = self;

  [[NSApp sharedUser] fetchMoments];
}

#pragma mark - PFMUserMomentsDelegate

- (void)didFetchMoments:(NSArray *)moments {
  PFMUser *user = [NSApp sharedUser];
  NSDictionary *dict = $dict([moments $map:^id (id moment) {
                               return [(PFMMoment *)moment toHash];
                             }], @"moments",
                             [user.coverPhoto iOSHighResURL], @"coverPhoto");
  NSString *json = [dict JSONRepresentation];
  // NSLog(@"%@", json);
  [self.webView stringByEvaluatingJavaScriptFromString:$str(@"Path.renderTemplate('moments', %@)", json)];
}

#pragma mark WebUIDelegate

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems {
  return nil;
}

@end
