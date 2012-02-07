#import "Application.h"
#import "PFMUtility.h"

@implementation PFMUtility

$singleton(PFMUtility);

- (id)initSingleton {
  return self;
}

+ (PFMUtility *)utility {
  return [self sharedPFMUtility];
}

- (void)showAlertSheetWithTitle:(NSString *)title message:(NSString *)message {
  
}

@end
