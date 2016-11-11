//
//  LLComment.h
//  FeedApp
//
//  Created by TechLoverr on 25/09/16.
//
//

#import <Foundation/Foundation.h>

@interface LLComment : NSObject

@property(nonatomic, assign) NSInteger releventScore;
@property(nonatomic, assign) NSInteger commentId;
@property(nonatomic, strong) NSString *commentText;
@property(nonatomic, strong) NSString *commentDisplayDate;
@property(nonatomic, assign) NSInteger contentType;
@property(nonatomic, assign) NSInteger contentId;
@property(nonatomic, assign) BOOL isActive;
@property(nonatomic, assign) NSInteger commentBy;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *photo;
@property(nonatomic, strong) NSDate *createdOn;
@property(nonatomic, assign) BOOL isFlagged;
@property(nonatomic, assign) NSInteger userId;
@property(nonatomic, strong) LLHood *hood;
@property(nonatomic, assign) NSInteger rank;
@property(nonatomic, strong) NSString *badges;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *photoThumb;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *photoFollower;
@property(nonatomic, strong) NSArray *commentRelaventData;
@property(nonatomic, assign) BOOL isRegistered;
@property(nonatomic, strong, readonly, getter=getFullName) NSString *fullName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
