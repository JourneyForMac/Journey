#import "TestHelper.h"
#import "PFMPlace.h"
#import "Application.h"
#import "SBJson.h"

SpecBegin(PFMPlace)

__block PFMPlace *place;

before(^{
  place = [PFMPlace new];
  place.oid = @"place.id";

  place.name = @"Anideo HQ";
  place.latitude = 1.212312;
  place.longitude = 123.31232;
  place.country = @"Singapore";
});

describe(@"-JSONRepresentation", ^{
  it(@"returns a JSON string which contains the JSON representation of the comment", ^{
    NSString * placeJSON = [place JSONRepresentation];
    NSDictionary * placeDict = [placeJSON JSONValue];

    expect([placeDict $for:@"name"]).toEqual(@"Anideo HQ");
    expect([[placeDict $for:@"latitude"] floatValue]).toEqual(1.212312f);
    expect([[placeDict $for:@"longitude"] floatValue]).toEqual(123.31232f);
    expect([placeDict $for:@"country"]).toEqual(@"Singapore");
  });
});


SpecEnd
