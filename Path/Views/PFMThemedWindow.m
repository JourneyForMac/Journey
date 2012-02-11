#import "PFMThemedWindow.h"
#import "PFMRedLinenView.h"

@interface PFMThemedWindow ()

@property (nonatomic, retain) PFMRedLinenView *redLinenView;

@end

@implementation PFMThemedWindow

@synthesize
  redLinenView=_redLinenView
;

- (id)contentView {
  NSView *contentView = [super contentView];
  if(!self.redLinenView) {
    self.redLinenView = [[PFMRedLinenView alloc] initWithFrame:NSZeroRect];
    [self.redLinenView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
  }
  if(![self.redLinenView superview]) {
    NSView *themeFrame = [contentView superview];
    [self.redLinenView setFrame:[themeFrame frame]];
    [themeFrame addSubview:self.redLinenView positioned:NSWindowBelow relativeTo:[[themeFrame subviews] objectAtIndex:0]];
  }
  return contentView;
}

@end
