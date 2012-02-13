#import "PFMModel.h"

#define kMomentsAPIPath  @"/3/moment/feed/home"

@protocol PFMUserSignInDelegate;
@protocol PFMUserMomentsDelegate;

@class PFMPhoto;

@interface PFMUser : PFMModel

@property(nonatomic, copy) NSString * id;

@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *password;

@property(nonatomic) BOOL signingIn;
@property(nonatomic) BOOL fetchingMoments;

@property(nonatomic, copy) NSString *firstName;
@property(nonatomic, copy) NSString *lastName;
@property(nonatomic, retain) NSMutableArray  *fetchedMoments;

@property(nonatomic, retain) PFMPhoto * coverPhoto;
@property(nonatomic, retain) PFMPhoto * profilePhoto;

@property(nonatomic) __weak id<PFMUserSignInDelegate> signInDelegate;
@property(nonatomic) __weak id<PFMUserMomentsDelegate> momentsDelegate;

- (ASIHTTPRequest *)signIn;
- (ASIHTTPRequest *)fetchMomentsNewerThan:(NSDate *)date;
- (ASIHTTPRequest *)fetchMomentsOlderThan:(NSDate *)date;

- (void)saveCredentials;
- (void)loadCredentials;

- (NSDictionary *) toHash;
- (NSString *) JSONRepresentation;

@end

@protocol PFMUserSignInDelegate <NSObject>

- (void)didSignIn;
- (void)didFailSignInDueToInvalidCredentials;
- (void)didFailSignInDueToRequestError;

@end

@protocol PFMUserMomentsDelegate <NSObject>

- (void)didFetchMoments:(NSArray *)moments;

@end
