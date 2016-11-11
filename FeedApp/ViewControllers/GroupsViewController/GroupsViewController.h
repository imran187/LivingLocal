//
//  GroupsViewController.h
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import "VSBaseViewController.h"

@interface GroupsViewController : VSBaseViewController
@property(nonatomic, strong) NSString *userId;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property(nonatomic, assign) NSInteger hoodId;
@end
