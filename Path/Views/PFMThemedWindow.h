#import <Cocoa/Cocoa.h>

@class
  PFMRedLinenView
;

@interface PFMThemedWindow : NSWindow {
  PFMRedLinenView *_redLinenView;
}

@property (nonatomic, retain) PFMRedLinenView *redLinenView;

@end
