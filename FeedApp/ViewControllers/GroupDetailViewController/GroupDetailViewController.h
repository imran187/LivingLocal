//
//  GroupDetailViewController.h
//  FeedApp
//
//  Created by TechLoverr on 18/09/16.
//
//

#import <UIKit/UIKit.h>

@interface GroupDetailViewController : UIViewController
@property(strong, nonatomic) LLGroup *group;
@property(strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@property(assign, nonatomic) NSInteger pageNumber;
@end
