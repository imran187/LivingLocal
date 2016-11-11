//
//  LLGroup.h
//  FeedApp
//
//  Created by TechLoverr on 05/10/16.
//
//

#import <Foundation/Foundation.h>

@interface LLGroup : NSObject

@property(nonatomic, assign) NSInteger groupId;
@property(nonatomic, strong) NSString *groupName;
@property(nonatomic, strong) LLSection *section;
@property(nonatomic, strong) NSString *groupCoverPhoto;
@property(nonatomic, strong) NSString *groupDescription;
@property(nonatomic, strong) NSString *createdBy;
@property(nonatomic, strong) NSDate *createdOn;
@property(nonatomic, strong) NSDate *updatedOn;
@property(nonatomic, assign) BOOL isFlagged;
@property(nonatomic, assign) NSInteger userId;
@property(nonatomic, strong) LLHood *hood;
@property(nonatomic, assign) BOOL userJoined;
@property(nonatomic, strong) NSString *badges;
@property(nonatomic, strong) NSString *groupStatus;
@property(nonatomic, assign) NSInteger hoodersCount;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, assign) NSString *userPhoto;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
