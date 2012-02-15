#import "PFMModel.h"

#define kMomentsAPIPath  @"/3/moment/feed/home"

@protocol PFMUserSignInDelegate;
@protocol PFMUserMomentsDelegate;

@class PFMPhoto;

@interface PFMUser : PFMModel

@property(nonatomic, copy) NSString * id;

@property(nonatomic, copy) NSString *email;
@property(nonatomic, copy) NSString *password;

@property(nonatomic, getter=isSigningIn) BOOL signingIn;
@property(nonatomic, getter=isSignedIn)  BOOL signedIn;
@property(nonatomic, getter=isFetchingMoments) BOOL fetchingMoments;

@property(nonatomic, copy) NSString *firstName;
@property(nonatomic, copy) NSString *lastName;
@property(nonatomic, retain) NSMutableArray  *fetchedMoments;

@property(nonatomic, retain) PFMPhoto * coverPhoto;
@property(nonatomic, retain) PFMPhoto * profilePhoto;

@property(nonatomic, retain) NSMutableDictionary * allMomentIds;
@property(nonatomic, retain) NSMutableArray      * allMoments;

@property(nonatomic) __weak id<PFMUserSignInDelegate> signInDelegate;
@property(nonatomic) __weak id<PFMUserMomentsDelegate> momentsDelegate;

- (ASIHTTPRequest *)signIn;
- (ASIHTTPRequest *)fetchMomentsNewerThan:(double)date;
- (ASIHTTPRequest *)fetchMomentsOlderThan:(double)date;
- (void)parseMomentsJSON:(NSString *)json
             insertAtTop:(BOOL)atTop;

- (void)saveCredentials;
- (void)loadCredentials;
- (void)deleteCredentials;

- (NSDictionary *) toHash;
- (NSString *) JSONRepresentation;

@end

@protocol PFMUserSignInDelegate <NSObject>

- (void)didSignIn;
- (void)didFailSignInDueToInvalidCredentials;
- (void)didFailSignInDueToRequestError;

@end

@protocol PFMUserMomentsDelegate <NSObject>

- (void)didFetchMoments:(NSArray *)moments
                  atTop:(BOOL)atTop;

@end
