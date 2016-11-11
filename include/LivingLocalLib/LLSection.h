//
//  LLSection.h
//  FeedApp
//
//  Created by TechLoverr on 25/09/16.
//
//

#import <Foundation/Foundation.h>

@interface LLSection : NSObject
@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, assign) BOOL isConfirmed;
@property(nonatomic, assign) BOOL isActive;
@property(nonatomic, strong) NSString *name;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (LLSection *)getSection:(NSInteger)sectionId;
@end
