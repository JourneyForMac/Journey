#import "PFMMainWindowControllerObjectController.h"
#import "PFMBooleanToShowHideJourneyStringTransformer.h"

@implementation PFMMainWindowControllerObjectController

+ (void)initialize {
  [super initialize];
  PFMBooleanToShowHideJourneyStringTransformer *transformer = [PFMBooleanToShowHideJourneyStringTransformer new];
  [PFMBooleanToShowHideJourneyStringTransformer setValueTransformer:transformer forName:@"PFMBooleanToShowHideJourneyStringTransformer"];
}

@end
