//
//  HelpViewController.h
//  FeedApp
//
//  Created by TechLoverr on 12/09/16.
//
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConstraint;
@property(nonatomic, assign) BOOL shouldHideLogo;
@property(nonatomic, assign) BOOL shouldNotNavigate;
@property(strong, nonatomic) NSArray *arrData;
@property(strong, nonatomic) UIColor *cellBGColor;
@property(strong, nonatomic) UIColor *cellSelectionColor;
@property(strong, nonatomic) UIColor *textColor;
@property(strong, nonatomic) UIColor *separatorColor;
@property(strong, nonatomic) NSString *titleString;
@end
