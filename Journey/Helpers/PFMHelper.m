#import "Application.h"
#import "PFMHelper.h"

@implementation PFMHelper

$singleton(PFMHelper);

- (id)initSingleton {
  return self;
}

+ (PFMHelper *)helper {
  return [self sharedPFMHelper];
}

#pragma mark -

- (void)showAlertSheetWithTitle:(NSString *)title message:(NSString *)message window:(NSWindow *)window {
  NSBeginAlertSheet(title, nil, nil, nil, window, nil, nil, nil, nil, message);
}

@end
