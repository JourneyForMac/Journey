#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class
  PFMToolbarViewController
, PFMMomentListViewController
, PFMView
;

@interface PFMMainWindowController : NSWindowController <
  NSWindowDelegate
> {
  NSView *_toolbarViewWrapper;
  PFMView *_momentListViewWrapper;
  PFMView *_titleBarView;
  PFMToolbarViewController *_toolbarViewController;
  PFMMomentListViewController *_momentListViewController;
}

@property (nonatomic, retain) IBOutlet NSView *toolbarViewWrapper;
@property (nonatomic, retain) IBOutlet PFMView *momentListViewWrapper;
@property (nonatomic, retain) IBOutlet PFMView *titleBarView;
@property (nonatomic, retain) PFMToolbarViewController *toolbarViewController;
@property (nonatomic, retain) PFMMomentListViewController *momentListViewController;

- (void)hideWindow;

@end
