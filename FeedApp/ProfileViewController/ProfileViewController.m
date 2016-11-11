//
//  ProfileViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "ActivityViewController.h"
#import "EventsViewController.h"
#import "FeedsViewController.h"
#import "GroupsViewController.h"
#import "ProfileOptionsCollectionView.h"
#import "ProfileViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

#define kUserSettingSegue @"toUserSettings"
#define kFeedsSegue @"toFeeds"
#define kInviteFriendSegue @"toInviteFriend"

@interface ProfileViewController () <UITextViewDelegate>
@property(weak, nonatomic) IBOutlet UILabel *lblHeaderName;
@property(weak, nonatomic) IBOutlet UITextView *txtAbout;
@property(weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property(weak, nonatomic)
    IBOutlet ProfileOptionsCollectionView *colProfileOptions;
@property(weak, nonatomic) IBOutlet UIButton *btnEditProfile;
@property(weak, nonatomic) IBOutlet UIButton *btnEditAbout;
@property(weak, nonatomic) IBOutlet UIImageView *imgUserFull;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTextheight;
@property(weak, nonatomic) IBOutlet LLLabel *lblRank;
@property(weak, nonatomic) IBOutlet UILabel *lblPlaceholder;
@property(weak, nonatomic) IBOutlet UIView *headerView2;

@end

@implementation ProfileViewController
- (IBAction)closePressed:(id)sender {
  [self dismissViewControllerAnimated:YES
                           completion:^{

                           }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _txtAbout.delegate = self;
  _btnEditAbout.hidden = _isFriendProfile;
  _btnEditProfile.hidden = _isFriendProfile;
  _headerView2.hidden = self.tabBarController;
  if (_user == nil) {
    _user = ServiceManager.loggedUser;
  }

  _lblRank.text = [@"Rank " stringByAppendingFormat:@"%lu", _user.rank];

  [_imgUserFull sd_setImageWithURL:[NSURL URLWithString:_user.photo]
                  placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
  _txtAbout.text = _user.bio;
  _lblPlaceholder.hidden = _user.bio.length > 0;
  _isFriendProfile = _user.userID != ServiceManager.loggedUser.userID;
  if (_isFriendProfile) {
    _lblPlaceholder.hidden = YES;
    _colProfileOptions.arrOptions = @[ @"Activities", @"Groups", @"Events" ];
    _txtAbout.text = @"";

    _colProfileOptions.arrImages = @[ @"activity", @"groups", @"events" ];
    _colProfileOptions.center =
        CGPointMake(self.view.center.x, _colProfileOptions.center.y);
    [self.view updateConstraintsIfNeeded];
    [_colProfileOptions reloadData];
  }

  _colProfileOptions.selectionHandler = ^(NSIndexPath *indexPath) {
    if (!_isFriendProfile) {
      if (indexPath.item == 3) {
        [self performSegueWithIdentifier:kUserSettingSegue sender:nil];
      } else if (indexPath.item == 4) {
        [self performSegueWithIdentifier:kInviteFriendSegue sender:nil];
      }
    }

    if (indexPath.item == 0) {
      [self performSegueWithIdentifier:@"toActivity" sender:nil];
    }

    if (indexPath.item == 1) {
      [self performSegueWithIdentifier:@"toGroups" sender:nil];
    }

    if (indexPath.item == 2) {
      [self performSegueWithIdentifier:@"toEvents" sender:nil];
    }

  };

  if (self.tabBarController)
    [APPDelegate.tabBarController.customTabbar
        selectItemAtIndex:TabBarItemTypeNone];
  [_lblPlaceholder.superview bringSubviewToFront:_lblPlaceholder];
  _imgArrow.hidden = SCREEN_WIDTH != 320 || _isFriendProfile;
  _colProfileOptions.imgArrow = _imgArrow;
}

- (void)viewDidAppear:(BOOL)animated {
  _constraintTextheight.constant = _txtAbout.contentSize.height + 10;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _lblName.text = _user.fullName;
  _lblHeaderName.text = _user.fullName;
  self.lblHood.text = _user.hoodName;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  textView.editable = NO;
  _scrollView.contentOffset = CGPointZero;
  _btnEditAbout.selected = NO;
  textView.scrollEnabled = YES;
  textView.layer.borderWidth = 0.0;
  _lblPlaceholder.hidden = textView.text.length > 0;

  if (![textView.text isEqualToString:_user.bio]) {
    NSString *oldBio = _user.bio;
    _user.bio = textView.text;
    [APPDelegate startLoadingView];
    [ServiceManager updateBioFor:_user
                    onCompletion:^(BOOL success) {
                      [APPDelegate stopLoadingView];
                      if (success) {
                        [self showAlertWithMessage:@"Profile Updated"];
                      } else {
                        _user.bio = oldBio;
                        textView.text = _user.bio;
                        _lblPlaceholder.hidden = textView.text.length > 0;
                      }
                    }];
  }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  textView.layer.borderWidth = 1.0;
  textView.scrollEnabled = YES;
  textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _lblPlaceholder.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView {

  _scrollView.contentOffset =
      CGPointMake(0, _scrollView.contentOffset.y + textView.contentSize.height +
                         10 - _constraintTextheight.constant);
  _constraintTextheight.constant = textView.contentSize.height + 10;
}

- (IBAction)aboutEditPressed:(UIButton *)sender {
  if (sender.selected == YES) {
    _txtAbout.editable = NO;
    _scrollView.contentOffset = CGPointZero;
    [_txtAbout resignFirstResponder];
    _btnEditAbout.selected = NO;
    return;
  }
  _txtAbout.editable = YES;
  [_txtAbout becomeFirstResponder];
  _btnEditAbout.selected = YES;
}

- (IBAction)actionEditProfilePic:(id)sender {

  [self pickImageWithTitle:nil
              OnCompletion:^(UIImage *image) {
                NSString *oldPath = ServiceManager.loggedUser.photo;
                _imgUserFull.image = image;
                self.imgUser.image = image;
                [APPDelegate startLoadingView];
                [ServiceManager
                    uploadBlobToContainer:image
                             onCompletion:^(BOOL success, NSString *path) {

                               if (success) {
                                 ServiceManager.loggedUser.photo = path;
                                 [ServiceManager
                                     updateUserFor:ServiceManager.loggedUser
                                      onCompletion:^(BOOL success) {
                                        [APPDelegate stopLoadingView];
                                        if (!success) {
                                          ServiceManager.loggedUser.photo =
                                              oldPath;
                                        }
                                      }];
                               } else {
                                 [APPDelegate stopLoadingView];
                                 ServiceManager.loggedUser.photo = oldPath;
                               }
                             }];
              }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"toActivity"]) {
    ActivityViewController *vc = (ActivityViewController *)
        [segue.destinationViewController topViewController];
    vc.user = _user;
  }

  if ([segue.identifier isEqualToString:@"toGroups"]) {
    GroupsViewController *vc = (GroupsViewController *)
        [segue.destinationViewController topViewController];
    vc.userId = _user.userID;
    vc.hoodId = _user.hoodId;
  }
  if ([segue.identifier isEqualToString:@"toEvents"]) {
    EventsViewController *vc = (EventsViewController *)
        [segue.destinationViewController topViewController];
    vc.userId = _user.userID;
    vc.hoodId = _user.hoodId;
  }
}

@end
