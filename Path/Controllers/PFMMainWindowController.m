#import "PFMMainWindowController.h"
#import "Application.h"
#import "PFMMomentListViewController.h"
#import "PFMToolbarViewController.h"

@implementation PFMMainWindowController

@synthesize
  toolbarViewWrapper=toolbarViewWrapper
, momentListViewWrapper=_momentListViewWrapper
, toolbarViewController=_toolbarViewController
, momentListViewController=_momentListViewController
;

- (id)init {
  self = [super initWithWindowNibName:@"MainWindow"];
  return self;
}

- (void)awakeFromNib {
  if(![[NSUserDefaults standardUserDefaults] objectForKey:@"NSWindow Frame MainWindow"]) {
    // if frame autosave is not found
    NSSize initialWindowSize = [[self window] frame].size;
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    CGFloat newHeight = floorf(screenFrame.size.height * 0.8);
    [self.window setFrame:NSMakeRect((screenFrame.size.width - initialWindowSize.width) / 2.0
                                   , (screenFrame.size.height - newHeight) / 2.0
                                   , initialWindowSize.width, newHeight) display:NO];
  }
  [self.window setFrameAutosaveName:@"MainWindow"];
}

- (void)windowDidLoad {
  [super windowDidLoad];

  self.momentListViewController = [PFMMomentListViewController new];
  NSView *momentListView = [self.momentListViewController view];
  [self.momentListViewWrapper addSubview:momentListView];
  [momentListView setFrame:[self.momentListViewWrapper bounds]];

  self.toolbarViewController = [PFMToolbarViewController new];
  NSView *toolbarView = [self.toolbarViewController view];
  [self.toolbarViewWrapper addSubview:toolbarView];
  [toolbarView setFrame:[self.toolbarViewWrapper bounds]];
}

@end
