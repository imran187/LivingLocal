//
//  EventsViewController.h
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import "VSBaseViewController.h"

@interface EventsViewController : VSBaseViewController
@property(nonatomic, strong) NSString *userId;
@property(weak, nonatomic) IBOutlet UIButton *btnCreate;
@property(nonatomic, assign) NSInteger hoodId;
@end
