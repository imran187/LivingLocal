//
//  RightToLeftAnimationController.h
//  FeedApp
//
//  Created by TechLoverr on 23/09/16.
//
//

#import <Foundation/Foundation.h>

@interface RightToLeftAnimationController
    : NSObject <UIViewControllerAnimatedTransitioning>
@property(nonatomic, assign) BOOL presenting;
@end
