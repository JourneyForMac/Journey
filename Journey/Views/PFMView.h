#import <Cocoa/Cocoa.h>

@interface PFMView : NSView {
  NSColor *_backgroundColor;
  void(^_drawRectBlock)(NSRect rect);
}

@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, copy) void(^drawRectBlock)(NSRect rect);

@end
