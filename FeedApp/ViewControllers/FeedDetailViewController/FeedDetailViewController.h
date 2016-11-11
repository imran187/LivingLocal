//
//  FeedDetailViewController.h
//  FeedApp
//
//  Created by TechLoverr on 07/09/16.
//
//

#import "VSBaseViewController.h"
#import "LLHeaderView.h"
#import "LLHeaderLabel.h"

@interface FeedDetailViewController : VSBaseViewController <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property(weak, nonatomic) IBOutlet UITextView *txtComment;
@property(strong, nonatomic) LLPost *post;
@property(assign) BOOL shouldStartEditing;
@property (weak, nonatomic) IBOutlet LLHeaderView *headerView2;
@property (weak, nonatomic) IBOutlet LLHeaderLabel *lblGroupName;
@property (weak, nonatomic) IBOutlet LLHeaderView *headerView;
@property(strong, nonatomic) LLGroup *group;
@end
