#import "TestHelper.h"
#import "PFMLocation.h"
#import "Application.h"
#import "SBJson.h"

SpecBegin(PFMLocation)

__block PFMLocation *location;

before(^{
  location = [PFMLocation new];
  location.id = @"comment.id";
  location.weatherConditions = @"Nice and Breezy";
  location.latitude = 1.212312;
  location.longitude = 123.31232;
  location.countryName = @"Singapore";
});

describe(@"-JSONRepresentation", ^{
  it(@"returns a JSON string which contains the JSON representation of the comment", ^{
    NSString * locationJSON = [location JSONRepresentation];
    NSDictionary * locationDict = [locationJSON JSONValue];

    expect([locationDict $for:@"weatherConditions"]).toEqual(@"Nice and Breezy");
    expect([[locationDict $for:@"latitude"] floatValue]).toEqual(1.212312f);
    expect([[locationDict $for:@"longitude"] floatValue]).toEqual(123.31232f);
    expect([locationDict $for:@"countryName"]).toEqual(@"Singapore");
  });
});


SpecEnd
