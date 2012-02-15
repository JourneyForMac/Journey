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

  [[NSApp sharedUser] fetchMomentsNewerThan:0.0];
}

- (void)refreshFeed {
  PFMUser *user = [NSApp sharedUser];
  PFMMoment *firstMoment = nil;
  NSArray *fetchedMoments = user.fetchedMoments;
  if(fetchedMoments && [fetchedMoments count] > 0) {
    firstMoment = [fetchedMoments objectAtIndex:0];
  }
  [user fetchMomentsNewerThan:firstMoment.createdAt];
}

#pragma mark - PFMUserMomentsDelegate

- (void)didFetchMoments:(NSArray *)moments {
  PFMUser *user = [NSApp sharedUser];
  NSDictionary *dict = $dict([moments $map:^id (id moment) {
                               return [(PFMMoment *)moment toHash];
                             }], @"moments",
                             [user.coverPhoto iOSHighResURL], @"coverPhoto",
                             [user.profilePhoto iOSHighResURL], @"profilePhoto");
  NSString *json = [dict JSONRepresentation];
//  NSLog(@">> %@", json);
  [self.webView stringByEvaluatingJavaScriptFromString:$str(@"Path.renderTemplate('feed', %@)", json)];
}

#pragma mark - WebUIDelegate

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems {
  return nil;
}

#pragma mark - WebFrameLoadDelegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
  if([actionInformation objectForKey:WebActionNavigationTypeKey]) {
    NSURL *url = [actionInformation objectForKey:WebActionOriginalURLKey];
    if(url) {
      if([[url absoluteString] hasSuffix:@"#refresh_feed"]) {
        [self refreshFeed];
        return;
      }
    }
  }
  [listener use];
}

@end
