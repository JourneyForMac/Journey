#import "TestHelper.h"
#import "SSKeychain.h"

void resetUserDefaultsAndKeychain(void) {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
  NSArray *accounts = [SSKeychain accountsForService:kPathKeychainServiceName];
  for(id account in accounts) {
    [SSKeychain deletePasswordForService:kPathKeychainServiceName account:account];
  }
}
