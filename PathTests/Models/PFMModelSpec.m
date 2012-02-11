#import "TestHelper.h"
#import "PFMModel.h"

SpecBegin(PFMModel)

__block PFMModel *model;

before(^{
  model = [PFMModel new];
});

describe(@"-requestWithPath:completionBlock:failedBlock:", ^{
  it(@"creates and returns ASIHTTPRequest object with full request url", ^{
    ASIHTTPRequest *request = [model requestWithPath:@"/3/user/settings"];
    expect([request.url absoluteString]).toEqual($str(@"%@/3/user/settings", kPathAPIHost));
  });
});

SpecEnd
