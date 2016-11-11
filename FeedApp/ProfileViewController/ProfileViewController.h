//
//  ProfileViewController.h
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : VSBaseViewController
@property(nonatomic, assign) BOOL isFriendProfile;
@property(nonatomic, strong) LLUser *user;
@property(nonatomic, assign) IBOutlet UILabel *lblName;
@property(weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property(nonatomic, strong) void (^imageSelectionHandler)(UIImage *);
@end
