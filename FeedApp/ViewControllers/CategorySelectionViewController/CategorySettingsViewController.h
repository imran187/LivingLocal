//
//  CategorySelectionViewController.h
//  FeedApp
//
//  Created by TechLoverr on 17/09/16.
//
//

#import <UIKit/UIKit.h>

@interface CategorySettingsViewController : UIViewController

@end
@interface CatSelCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIImageView *imgVIew;
@property(weak, nonatomic) IBOutlet UILabel *lblName;
@property(weak, nonatomic) IBOutlet UIButton *btnCheck;

@end
