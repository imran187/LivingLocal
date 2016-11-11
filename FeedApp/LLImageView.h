//
//  LLImageView.h
//  FeedApp
//
//  Created by TechLoverr on 25/10/16.
//
//

#import <UIKit/UIKit.h>

@interface LLImageView : UIImageView
@property(nonatomic, assign) NSInteger hoodId;
@property(nonatomic, strong) NSString *userID;
- (void)imagePressed;
@end
