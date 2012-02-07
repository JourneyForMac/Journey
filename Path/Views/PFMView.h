#import <Cocoa/Cocoa.h>

@interface PFMView : NSView

@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, copy) void(^drawRectBlock)(NSRect rect);

@end
