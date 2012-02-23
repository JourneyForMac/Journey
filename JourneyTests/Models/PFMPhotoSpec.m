#import "TestHelper.h"
#import "PFMPhoto.h"
#import "Application.h"
#import "SBJson.h"

SpecBegin(PFMPhoto)

__block PFMPhoto *photo;
__block id mockPhoto;

before(^{
  photo = [PFMPhoto new];
  mockPhoto = [OCMockObject partialMockForObject:photo];
  photo.iOSLowResFileName = @"1x.jpg";
  photo.iOSHighResFileName = @"2x.jpg";
  photo.webFileName = @"web.jpg";
  photo.originalFileName = @"original.jpg";
  photo.baseURL = @"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19";
});

describe(@"-iOSLowResURL", ^{
  it(@"returns the full iOS low-res URL", ^{
    expect(photo.iOSLowResURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/1x.jpg");
  });
});

describe(@"-iOSHighResURL", ^{
  it(@"returns the full iOS high-res URL", ^{
    expect(photo.iOSHighResURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/2x.jpg");
  });
});

describe(@"-webURL", ^{
  it(@"returns the full web URL", ^{
    expect(photo.webURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/web.jpg");
  });
});

describe(@"-originalURL", ^{
  it(@"returns the full original URL", ^{
    expect(photo.originalURL).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/original.jpg");
  });
});

describe(@"-JSONRepresentation", ^{
  it(@"returns a JSON string which contains the URLs to the images", ^{
    NSString * photoJSON = [photo JSONRepresentation];

    NSDictionary * photoDict = [photoJSON JSONValue];

    expect([photoDict $for:@"iOSLowResURL"]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/1x.jpg");
    expect([photoDict $for:@"iOSHighResURL"]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/2x.jpg");
    expect([photoDict $for:@"webURL"]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/web.jpg");
    expect([photoDict $for:@"originalURL"]).toEqual(@"https://s3-us-west-1.amazonaws.com/images.path.com/static/covers/19/original.jpg");
  });
});


SpecEnd
