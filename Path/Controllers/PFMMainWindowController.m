#import "PFMMainWindowController.h"
#import "Application.h"
#import "PFMMomentListViewController.h"
#import "PFMToolbarViewController.h"
#import "PFMView.h"
#import "PathAppDelegate.h"

@interface PFMMainWindowController ()
@end

@implementation PFMMainWindowController

@synthesize
  toolbarViewWrapper=toolbarViewWrapper
, momentListViewWrapper=_momentListViewWrapper
, titleBarView=_titleBarView
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

- (void)loadWindow {
  [super loadWindow];

  NSWindow *window = [self window];

  // set up titlebar view
  __block PFMView *titleBarView = self.titleBarView;
  NSView *contentView = [window contentView];
  NSView *themeFrame = [contentView superview];
  [themeFrame addSubview:titleBarView positioned:NSWindowBelow relativeTo:contentView];
  NSRect windowFrame = [window frame];
  NSRect titleBarFrame = [titleBarView frame];
  [titleBarView setFrame:NSMakeRect(0, windowFrame.size.height - titleBarFrame.size.height,
                                    windowFrame.size.width, titleBarFrame.size.height)];
  titleBarView.drawRectBlock = ^(NSRect rect) {
    NSRect bounds = [titleBarView bounds];
    [[NSColor colorWithCalibratedWhite:0.0 alpha:0.5] set];
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0, 0.5)];
    [path lineToPoint:NSMakePoint(bounds.size.width, 0.5)];
    [path stroke];
    [[NSColor colorWithCalibratedWhite:0.0 alpha:0.2] set];
    path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0, 1.5)];
    [path lineToPoint:NSMakePoint(bounds.size.width, 1.5)];
    [path stroke];
    [[NSColor colorWithCalibratedWhite:1.0 alpha:0.5] set];
    CGFloat lineDash[] = { 4.0, 2.0 };
    path = [NSBezierPath bezierPath];
    [path setLineDash:lineDash count:2 phase:1.0];
    [path moveToPoint:NSMakePoint(0.0, 3.5)];
    [path lineToPoint:NSMakePoint(bounds.size.width, 3.5)];
    [path stroke];
    [[NSColor colorWithCalibratedWhite:0.0 alpha:0.2] set];
    path = [NSBezierPath bezierPath];
    [path setLineDash:lineDash count:2 phase:1.0];
    [path moveToPoint:NSMakePoint(0.0, 2.5)];
    [path lineToPoint:NSMakePoint(bounds.size.width, 2.5)];
    [path stroke];
  };

  // load subviews
  self.momentListViewWrapper.backgroundColor = [NSColor whiteColor];

  self.momentListViewController = [PFMMomentListViewController new];
  NSView *momentListView = [self.momentListViewController view];
  [self.momentListViewWrapper addSubview:momentListView];
  [momentListView setFrame:[self.momentListViewWrapper bounds]];

  self.toolbarViewController = [PFMToolbarViewController new];
  NSView *toolbarView = [self.toolbarViewController view];
  [self.toolbarViewWrapper addSubview:toolbarView];
  [toolbarView setFrame:[self.toolbarViewWrapper bounds]];
}

- (void)hideWindow {
  [self.window orderOut:self];
}

#pragma mark - NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender {
  [self hideWindow];
  return NO;
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
  if([self.momentListViewController webViewScrollTop] <= 243) {
    [(PathAppDelegate *)[NSApp delegate] highlightStatusItem:NO];
  }
}

@end
