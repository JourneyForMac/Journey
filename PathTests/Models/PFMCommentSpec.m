#import "TestHelper.h"
#import "PFMComment.h"
#import "Application.h"
#import "SBJson.h"

SpecBegin(PFMComment)

__block PFMComment *comment;

before(^{
  comment = [PFMComment new];
  comment.id = @"comment.id";
  comment.body = @"Comment Body";
  comment.state = @"Live";
});

describe(@"-JSONRepresentation", ^{
  it(@"returns a JSON string which contains the JSON representation of the comment", ^{
    NSString * commentJSON = [comment JSONRepresentation];
    NSDictionary * commentDict = [commentJSON JSONValue];

    expect([commentDict $for:@"body"]).toEqual(@"Comment Body");
    expect([commentDict $for:@"state"]).toEqual(@"Live");
  });

});


SpecEnd
