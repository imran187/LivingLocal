//
//  LLPost.h
//  FeedApp
//
//  Created by TechLoverr on 25/09/16.
//
//

#import <Foundation/Foundation.h>

@interface LLPost : NSObject
@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) NSInteger userId;
@property(nonatomic, strong) NSString *userImage;
@property(nonatomic, strong) NSString *contentDescription;
@property(nonatomic, assign) NSInteger contentType;
@property(nonatomic, assign) NSInteger totalComments;
@property(nonatomic, strong) NSString *contentImage;
@property(nonatomic, strong) NSDate *createdOn;
@property(nonatomic, strong) NSDate *sortDate;
@property(nonatomic, strong) NSString *displayDate;
@property(nonatomic, strong) NSArray *postReleventData;
@property(nonatomic, assign) BOOL isAnswered;
@property(nonatomic, assign) NSInteger rowNumber;
@property(nonatomic, assign) NSInteger releventScore;
@property(nonatomic, assign) NSInteger favouriteUserId;
@property(nonatomic, assign) NSInteger articleHood;
@property(nonatomic, assign) NSInteger userHood;
@property(nonatomic, strong) LLSection *section;
@property(nonatomic, strong) NSArray *contentImageList;
@property(nonatomic, strong) NSArray *comments;
@property(nonatomic, assign) float mainImageHeight;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithRecommecdationDictionary:(NSDictionary *)dict;
- (instancetype)initWithSearchDictionary:(NSDictionary *)dict ;
@end
