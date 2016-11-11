//
//  CategorySelectionViewController.h
//  FeedApp
//
//  Created by Vishal on 03/09/16.
//
//

#import <UIKit/UIKit.h>

@interface CategorySelectionViewController : UIViewController

@end

@interface CustomCatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@end