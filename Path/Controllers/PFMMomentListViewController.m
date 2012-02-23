#import "PFMMomentListViewController.h"
#import "Application.h"
#import "SBJson.h"
#import "PFMMoment.h"
#import "PFMUser.h"
#import "PFMPhoto.h"
#import "PathAppDelegate.h"

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
  NSArray *fetchedMoments = user.allMoments;
  if(fetchedMoments && [fetchedMoments count] > 0) {
    firstMoment = [fetchedMoments objectAtIndex:0];
  }
  [user fetchMomentsNewerThan:firstMoment.createdAt];
}

- (void)loadOldMoments {
  PFMUser *user = [NSApp sharedUser];
  PFMMoment *lastMoment = nil;
  NSArray *fetchedMoments = user.allMoments;
  if(fetchedMoments && [fetchedMoments count] > 0) {
    lastMoment = [fetchedMoments $at:([fetchedMoments count] - 1)];
  }

  [user fetchMomentsOlderThan:lastMoment.createdAt];
}

#pragma mark - PFMUserMomentsDelegate

- (void)didFetchMoments:(NSArray *)moments
                  atTop:(BOOL)atTop {
  PFMUser *user = [NSApp sharedUser];
  NSString * javascriptToExecute = nil;

  NSDictionary *dict = $dict([moments $map:^id (id moment) {
                               return [(PFMMoment *)moment toHash];
                             }], @"moments",
                             [user.coverPhoto iOSHighResURL], @"coverPhoto",
                             [user.profilePhoto iOSHighResURL], @"profilePhoto");
  NSString *json = [dict JSONRepresentation];
  //  NSLog(@">> %@", json);
  if([moments count] > 0) {
    if (atTop) {
      javascriptToExecute = $str(@"Path.renderTemplate('feed', %@, true)", json);
      NSInteger scrollTop = [self webViewScrollTop];
      if(scrollTop > 0 || ![self.view.window isKeyWindow]) {
        [(PathAppDelegate *)[NSApp delegate] highlightStatusItem:YES];
      }
    } else {
      javascriptToExecute = $str(@"Path.renderTemplate('feed', %@, false)", json);
    }
  } else {
    javascriptToExecute = @"Path.didCompleteRefresh()";
  }

  [self.webView stringByEvaluatingJavaScriptFromString:javascriptToExecute];
}

- (void)didFailToFetchMoments {
  [self.webView stringByEvaluatingJavaScriptFromString:@"Path.didCompleteRefresh()"];
}

- (NSInteger)webViewScrollTop {
  return [[self.webView stringByEvaluatingJavaScriptFromString:@"$(document).scrollTop()"] integerValue];
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
      NSString *urlString = [url absoluteString];
      if([urlString hasSuffix:@"#refresh_feed"]) {
        [self refreshFeed];
        return;
      } else if([urlString hasSuffix:@"#load_old_moments"]) {
        [self loadOldMoments];
        return;
      } else if([urlString hasSuffix:@"#clear_status_item_highlight"]) {
        [(PathAppDelegate *)[NSApp delegate] highlightStatusItem:NO];
        [self.webView stringByEvaluatingJavaScriptFromString:@"Path.removeHashFragment()"];
        return;
      }
    }
  }
  [listener use];
}

@end
