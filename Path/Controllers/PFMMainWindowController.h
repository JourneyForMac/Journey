#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class
  PFMToolbarViewController
, PFMMomentListViewController
;

@interface PFMMainWindowController : NSWindowController

@property (nonatomic, retain) IBOutlet NSView *toolbarViewWrapper;
@property (nonatomic, retain) IBOutlet NSView *momentListViewWrapper;
@property (nonatomic, retain) IBOutlet NSImageView *titleBarLogoView;
@property (nonatomic, retain) PFMToolbarViewController *toolbarViewController;
@property (nonatomic, retain) PFMMomentListViewController *momentListViewController;

@end
