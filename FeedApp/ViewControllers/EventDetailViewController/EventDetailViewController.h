//
//  EventDetailViewController.h
//  FeedApp
//
//  Created by TechLoverr on 19/09/16.
//
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property(weak, nonatomic) IBOutlet UITextField *txtComment;
@property(strong, nonatomic) LLEvent *event;
@end
