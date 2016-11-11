//
//  LLUser.h
//  FeedApp
//
//  Created by TechLoverr on 24/09/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Gender) { GenderNone, GenderMale, GenderFemale };

@interface LLUser : NSObject

@property(nonatomic, assign) Gender sex;
@property(nonatomic, strong) NSString *photoThumb;
@property(nonatomic, strong) NSString *photo;
@property(nonatomic, strong) NSString *userID;
@property(nonatomic, strong) NSString *badges;
@property(nonatomic, strong) NSString *bellNotification;
@property(nonatomic, strong) NSString *emailNotification;
@property(nonatomic, strong) NSString *interests;
@property(nonatomic, assign) NSInteger hoodId;
@property(nonatomic, assign) NSInteger noOfFollowers;
@property(nonatomic, assign) NSInteger noOfFollowing;
@property(nonatomic, assign) NSInteger rank;
@property(nonatomic, assign) NSInteger modifiedBy;
@property(nonatomic, strong) NSString *ipAddress;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *cityName;
@property(nonatomic, strong) NSString *hoodName;
@property(nonatomic, strong) NSString *photoFollower;
@property(nonatomic, strong) NSString *bio;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *merchantCode;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *mobileNumber;
@property(nonatomic, strong) NSString *countryCode;
@property(nonatomic, strong) NSString *aboutHood;
@property(nonatomic, strong) NSDate *updatedDate;
@property(nonatomic, strong) NSDate *birthDate;
@property(nonatomic, strong) NSDate *LastLoginTime;
@property(nonatomic, strong) NSDate *createdTime;
@property(nonatomic, assign) NSInteger sectionID;
@property(nonatomic, assign) NSInteger cityID;
@property(nonatomic, assign) NSInteger userRoleID;
@property(nonatomic, assign) BOOL isRegistered;
@property(nonatomic, assign) BOOL isActive;
@property(nonatomic, assign) BOOL isConfirmed;

@property(nonatomic, strong, readonly, getter=getFullName) NSString *fullName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionaryForHooders:(NSDictionary *)dict;
- (NSDictionary *)responseUpdateParams;
- (NSDictionary *)responseParams;
@end
