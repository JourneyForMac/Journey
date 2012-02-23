#import <Foundation/Foundation.h>
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"
#define HC_SHORTHAND
#import "OCHamcrest.h"

#import "Application.h"
#import "ASIHTTPRequest+Spec.h"

#define loadStringFixture(fileName) \
[NSString stringWithContentsOfFile:[[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingString:$str(@"/%@", (fileName))] encoding:NSUTF8StringEncoding error:NULL]

void resetUserDefaultsAndKeychain(void);
