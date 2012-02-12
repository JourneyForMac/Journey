#import "TestHelper.h"
#import "PFMComment.h"
#import "Application.h"
#import "SBJson.h"
#import "PFMUser.h"
#import "PFMLocation.h"

SpecBegin(PFMComment)

__block PFMComment *comment;
__block PFMLocation *location;
__block PFMUser *user;

before(^{
  comment = [PFMComment new];
  comment.id = @"comment.id";
  comment.body = @"Comment Body";
  comment.state = @"Live";

  user = [PFMUser new];
  user.firstName = @"Aloha";
  user.lastName = @"Boss";

  location = [PFMLocation new];
  location.id = @"location.id";
  location.latitude = 1.23456;
  location.longitude = 123.456;

  [[NSApp sharedUsers] setObject:user forKey:@"user.id"];
  [[NSApp sharedLocations] setObject:location forKey:@"location.id"];

  comment.locationId = @"location.id";
  comment.userId = @"user.id";
});

after(^{
  [NSApp resetSharedUsers];
  [NSApp resetSharedLocations];
});

describe(@"-JSONRepresentation", ^{
  it(@"returns a JSON string which contains the JSON representation of the comment", ^{
    NSString * commentJSON = [comment JSONRepresentation];
    NSDictionary * commentDict = [commentJSON JSONValue];

    expect([commentDict $for:@"body"]).toEqual(@"Comment Body");
    expect([commentDict $for:@"state"]).toEqual(@"Live");
    expect([(NSNumber *)[[commentDict $for:@"location"] $for:@"latitude"] floatValue]).toEqual(1.23456f);
    expect([(NSNumber *)[[commentDict $for:@"location"] $for:@"longitude"] floatValue]).toEqual(123.456f);
    expect([[commentDict $for:@"user"] $for:@"firstName"]).toEqual(@"Aloha");
    expect([[commentDict $for:@"user"] $for:@"lastName"]).toEqual(@"Boss");
  });

});


SpecEnd
