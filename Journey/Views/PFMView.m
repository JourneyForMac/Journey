#import "PFMView.h"

@implementation PFMView

@synthesize
  backgroundColor=_backgroundColor
, drawRectBlock=_drawRectBlock
;

- (void)drawRect:(NSRect)rect {
  if(self.backgroundColor) {
    [self.backgroundColor setFill];
    NSRectFill(rect);
  }
  if(self.drawRectBlock) {
    self.drawRectBlock(rect);
  }
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
  _backgroundColor = backgroundColor;
  [self setNeedsDisplay:YES];
}

@end
