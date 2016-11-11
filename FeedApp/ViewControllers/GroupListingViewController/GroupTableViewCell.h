//
//  GroupTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 05/10/16.
//
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet LLLabel *lblGroupName;
@property (weak, nonatomic) IBOutlet LLLabel *lblSectionName;
@property (weak, nonatomic) IBOutlet LLLabel *lblHoodersCount;

@end
