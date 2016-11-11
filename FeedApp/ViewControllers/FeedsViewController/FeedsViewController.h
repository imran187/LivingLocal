//
//  FeedsViewController.h
//  FeedApp
//
//  Created by TechLoverr on 03/09/16.
//
//

#import "VSBaseViewController.h"

@interface FeedsViewController : VSBaseViewController
@property(nonatomic, strong) LLUser *user;
@property(nonatomic, assign) NSInteger hood;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end
