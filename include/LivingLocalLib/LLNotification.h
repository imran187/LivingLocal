//
//  LLNotification.h
//  FeedApp
//
//  Created by TechLoverr on 13/10/16.
//
//

#import <Foundation/Foundation.h>

@interface LLNotification : NSObject

@property(nonatomic, strong) NSString *userPhoto;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *notification;
@property(nonatomic, strong) NSDate *notificationDate;
@property(nonatomic, strong) NSString *targetUserId;
@property(nonatomic, assign) NSInteger identifier;
@property(nonatomic, assign) NSInteger contentId;
@property(nonatomic, assign) NSInteger contentType;
@property(nonatomic, assign) NSInteger userNotificationType;
@property(nonatomic, assign) BOOL isNotificationRead;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
