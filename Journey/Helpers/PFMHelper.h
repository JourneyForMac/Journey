#import <Foundation/Foundation.h>

@interface PFMHelper : NSObject

- (id)initSingleton;
+ (PFMHelper *)sharedPFMHelper;
+ (PFMHelper *)helper;

- (void)showAlertSheetWithTitle:(NSString *)title message:(NSString *)message window:(NSWindow *)window;

@end
