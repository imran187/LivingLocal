//
//  VSBaseViewController.h
//
//  Created by Vishal on 29/12/15.
//  Copyright © 2015 vishal. All rights reserved.
//

#import "FilterView.h"
#import <UIKit/UIKit.h>

@interface VSBaseViewController : UIViewController
- (IBAction)showLeftMenuPressed:(id)sender;
@property(nonatomic, assign) IBOutlet UIImageView *imgUser;
@property(nonatomic, assign) IBOutlet UILabel *lblHood;
@property (weak, nonatomic) IBOutlet LLLabel *lblNotificationCount;
@property(nonatomic, strong) FilterView *filterView;
@property(nonatomic, copy) void (^selectionHandler)(void);
@end
