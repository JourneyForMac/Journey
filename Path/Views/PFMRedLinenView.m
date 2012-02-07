#import "PFMRedLinenView.h"

@implementation PFMRedLinenView

- (id)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    self.backgroundColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"RedLinenBg.png"]];
  }
  return self;
}

- (void)drawRect:(NSRect)rect {
  NSRect frame = [self frame];
	[[NSBezierPath bezierPathWithRoundedRect:frame xRadius:4.0 yRadius:4.0] addClip];
  [super drawRect:rect];
}

@end
