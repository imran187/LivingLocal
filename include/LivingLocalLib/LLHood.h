//
//  LLHood.h
//  FeedApp
//
//  Created by TechLoverr on 25/09/16.
//
//

#import <Foundation/Foundation.h>

@interface LLHood : NSObject
@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, assign) NSInteger cityId;
@property(nonatomic, strong) NSString *name;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (LLHood *)getHood:(NSInteger)hoodId;
@end
