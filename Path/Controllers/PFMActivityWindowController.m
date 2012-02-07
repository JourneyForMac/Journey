#import "PFMActivityWindowController.h"

@implementation PFMActivityWindowController

@synthesize
  webView=_webView
;

- (id)init {
  self = [super initWithWindowNibName:@"ActivityWindow"];
  return self;
}

- (void)awakeFromNib {
  if(![[NSUserDefaults standardUserDefaults] objectForKey:@"NSWindow Frame ActivityWindow"]) {
    NSSize initialWindowSize = [[self window] frame].size;
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    CGFloat newHeight = floorf(screenFrame.size.height * 0.8);
    [self.window setFrame:NSMakeRect((screenFrame.size.width - initialWindowSize.width) / 2.0
                                   , (screenFrame.size.height - newHeight) / 2.0
                                   , initialWindowSize.width, newHeight) display:NO];
  }
  [self.window setFrameAutosaveName:@"ActivityWindow"];
}

- (void)windowDidLoad {
  [super windowDidLoad];
}

@end
