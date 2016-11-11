//
//  LLEvent.h
//  FeedApp
//
//  Created by TechLoverr on 05/10/16.
//
//

#import <Foundation/Foundation.h>

@interface LLEvent : NSObject

@property(nonatomic, assign) NSInteger eventId;
@property(nonatomic, assign) NSInteger noOfIntrested;
@property(nonatomic, assign) NSInteger hoodId;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;
@property(nonatomic, strong) NSString *eventName;
@property(nonatomic, strong) LLSection *section;
@property(nonatomic, strong) NSString *eventCoverPhoto;
@property(nonatomic, strong) NSString *emailId;
@property(nonatomic, strong) NSString *eventDescription;
@property(nonatomic, strong) NSString *eventLink;
@property(nonatomic, strong) NSString *eventVenue;
@property(nonatomic, strong) NSString *eventThumbPhoto;
@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) NSDate *endTime;
@property(nonatomic, strong) NSString *fees;
@property(nonatomic, strong) NSString *age;
@property(nonatomic, strong) NSString *contactNo;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *createdBy;
@property(nonatomic, strong) NSString *createdByName;
@property(nonatomic, strong) NSString *createdByImage;
@property(nonatomic, strong) NSArray *imgArray;
@property(nonatomic, strong) NSArray *arrComments;
@property(nonatomic, assign) BOOL isInterested;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionaryDetail:(NSDictionary *)dict;

@end
