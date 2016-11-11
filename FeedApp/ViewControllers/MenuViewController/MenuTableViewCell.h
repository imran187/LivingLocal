//
//  MenuTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIImageView *imgView;
@property(weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UIView *viewSeperator;

@end
