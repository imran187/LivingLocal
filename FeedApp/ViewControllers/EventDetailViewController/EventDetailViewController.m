//
//  EventDetailViewController.m
//  FeedApp
//
//  Created by TechLoverr on 19/09/16.
//
//

#import "CommentTableViewCell.h"
#import "EventDetailViewController.h"
#import "EventHeaderTableViewCell.h"
#import "EventImageTableViewCell.h"
#import "EventInfoTableViewCell.h"
#import "EventMapTableViewCell.h"
#import "LLHeaderLabel.h"
#import "ParallaxHeaderView.h"

@interface EventDetailViewController () <
    UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,
    UITextFieldDelegate> {
  UITapGestureRecognizer *tapGesture;
}
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopConstraint;
@property(weak, nonatomic) IBOutlet UILabel *lblHoodHeaderTitle;
@property(weak, nonatomic) IBOutlet LLLabel *lblHeaderTitle;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;
@property(weak, nonatomic) IBOutlet LLHeaderLabel *lblTitle;
@property(weak, nonatomic) IBOutlet UITableView *iblEventDetail;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSNotificationCenter *notificationCenter =
      [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self
                         selector:@selector(keyBoardFrameWillUpdate:)
                             name:UIKeyboardWillChangeFrameNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(keyBoardFrameWillUpdate:)
                             name:UIKeyboardWillHideNotification
                           object:nil];
  self.view.userInteractionEnabled = NO;
  [ServiceManager
      getIsInterestedForEvent:_event.eventId
                 onCompletion:^(BOOL success) {
                   _event.isInterested = success;
                   [_iblEventDetail reloadData];

                   [ServiceManager
                       getProfileFor:_event.createdBy
                        onCompletion:^(BOOL success, LLUser *user) {
                          self.view.userInteractionEnabled = YES;
                          if (success) {
                            _event.createdByName = user.fullName;
                            _event.createdByImage = user.photo;
                            _event.hoodId = user.hoodId;
                            
                            NSDateFormatter *df = [NSDateFormatter new];
                            df.dateFormat = @"EEE, dd MMM";

                            _lblHeaderTitle.text =
                                _event.eventName.uppercaseString;
                            _lblHoodHeaderTitle.text = [NSString
                                stringWithFormat:
                                    @"%@ %@ - %@", _event.section.name,
                                    [df stringFromDate:_event.startDate],
                                    [df stringFromDate:_event.endDate]];
                            [_iblEventDetail reloadData];
                          }
                        }];

                   [ServiceManager
                           getEvent:_event.eventId
                       onCompletion:^(BOOL success, LLEvent *event) {
                         if (success) {
                           event.isInterested = _event.isInterested;
                           event.createdByName = _event.createdByName;
                           event.createdByImage = _event.createdByImage;
                             event.createdBy = _event.createdBy;
                           event.imgArray = _event.imgArray;
                           event.hoodId = _event.hoodId;
                           _event = event;
                           NSDateFormatter *df = [NSDateFormatter new];
                           df.dateFormat = @"EEE, dd MMM";
                           _lblHoodHeaderTitle.text = [NSString
                               stringWithFormat:
                                   @"%@ %@ - %@", _event.section.name,
                                   [df stringFromDate:_event.startDate],
                                   [df stringFromDate:_event.endDate]];
                           [_iblEventDetail reloadData];

                           [ServiceManager
                               getEventCommentsForEvent:_event.eventId
                                           onCompletion:^(BOOL success,
                                                          NSArray *comments) {
                                             self.view.userInteractionEnabled =
                                                 YES;
                                             if (success) {
                                               _event.arrComments = comments;
                                               [_iblEventDetail reloadData];
                                             }
                                           }];
                         }
                       }];

                   [ServiceManager
                       getAllImagesForEvent:_event.eventId
                               OnCompletion:^(BOOL success, NSArray *paths) {
                                 self.view.userInteractionEnabled = YES;
                                 if (success) {
                                   _event.imgArray = paths;
                                 }
                               }];

                 }];

  [self.view bringSubviewToFront:_txtComment];
  _txtComment.hidden = NO;
  _txtComment.leftView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  _txtComment.leftViewMode = UITextFieldViewModeAlways;
  _txtComment.delegate = self;
  APPDelegate.tabBarController.customTabbar.hidden = YES;
  ParallaxHeaderView *headerView = [ParallaxHeaderView
      parallaxHeaderViewWithImage:[UIImage imageNamed:@"Rest_2"]
                          forSize:CGSizeMake(SCREEN_WIDTH, 175)];
  [headerView.imageView
      sd_setImageWithURL:[NSURL URLWithString:_event.eventCoverPhoto]
        placeholderImage:[UIImage imageNamed:@"eventPlaceholder"]];
  _iblEventDetail.estimatedRowHeight = 100;
  _iblEventDetail.rowHeight = UITableViewAutomaticDimension;
  _iblEventDetail.delegate = self;
  _iblEventDetail.dataSource = self;
  _iblEventDetail.tableHeaderView = headerView;
  tapGesture =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tapped)];
  APPDelegate.tabBarController.customTabbar.hidden = YES;
  _labelHeightConstraint.constant = 175;
}

- (void)tapped {
  [self.view endEditing:YES];
}

- (void)keyBoardFrameWillUpdate:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  NSTimeInterval animationDuration;
  UIViewAnimationCurve animationCurve;

  [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
  [userInfo[UIKeyboardAnimationDurationUserInfoKey]
      getValue:&animationDuration];

  UIViewAnimationOptions animationOptions =
      (animationCurve
       << 16); // convert from UIViewAnimationCurve to UIViewAnimationOptions

  CGRect keyboardRect = [[[notification userInfo]
      objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

  _bottomConstraint.constant =
      [UIScreen mainScreen].bounds.size.height - keyboardRect.origin.y;

  [UIView animateWithDuration:animationDuration
                        delay:0
                      options:animationOptions
                   animations:^{

                     [self.view layoutIfNeeded];
                   }
                   completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self.view addGestureRecognizer:tapGesture];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [self.view removeGestureRecognizer:tapGesture];
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.view sendSubviewToBack:_iblEventDetail];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 4 + _event.arrComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  NSString *cellIdentifier = @"";

  switch (indexPath.row) {
  case 0: {
    cellIdentifier = @"HeaderCell";
    EventHeaderTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.event = _event;
    return cell;
  } break;
  case 1: {
    cellIdentifier = @"InfoCell";
    EventMapTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.event = _event;
    return cell;
  } break;
  case 2:

  {
    cellIdentifier = @"MapCell";
    EventInfoTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.event = _event;
    return cell;
  } break;
  case 3:

  {
    cellIdentifier = @"ImageCell";
    EventImageTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.event = _event;
    return cell;
  } break;

  default: {
    cellIdentifier = @"CommentCell";
    CommentTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.comment = _event.arrComments[indexPath.row - 4];

    cell.dividerView.hidden = NO;
    if (indexPath.row == 3 + _event.arrComments.count) {
      cell.dividerView.hidden = YES;
    }
      
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
    return cell;
  } break;
  }

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 3 && _event.imgArray.count == 0) {
    return 0;
  }

  return UITableViewAutomaticDimension;
}

- (IBAction)galleryPressed:(id)sender {
  [self.view endEditing:YES];
  UIView *slideView =
      [[[NSBundle mainBundle] loadNibNamed:@"SlideView" owner:nil options:nil]
          firstObject];

  slideView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
  [self.tabBarController.view addSubview:slideView];
  [UIView animateWithDuration:0.5
                   animations:^{
                     slideView.frame =
                         CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                   }];
}
- (IBAction)sharePressed:(id)sender {

  NSString *strData = @"Living Local";
  NSURL *url = [NSURL URLWithString:@"http://livinglocal.com"];
  UIActivityViewController *activityVC =
      [[UIActivityViewController alloc] initWithActivityItems:@[ strData, url ]
                                        applicationActivities:nil];
  [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  if (scrollView == _iblEventDetail) {
    [((ParallaxHeaderView *)_iblEventDetail.tableHeaderView)
        layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    _labelHeightConstraint.constant = (175 - scrollView.contentOffset.y > 44)
                                          ? 175 - scrollView.contentOffset.y
                                          : 44;
    _lblTitle.alpha = 1 / _iblEventDetail.tableHeaderView.frame.size.height *
                      (scrollView.contentOffset.y > 125 ? 2 : 1) *
                      scrollView.contentOffset.y;

    if (_lblTitle.alpha > 1) {
      _lblHoodHeaderTitle.hidden = NO;
      _lblHeaderTitle.hidden = NO;
      _headerTopConstraint.constant = 6;
      [UIView animateWithDuration:0.2
                       animations:^{
                         [self.view layoutIfNeeded];
                       }];
    } else {

      _headerTopConstraint.constant = 40;
      [UIView animateWithDuration:0.2
          animations:^{
            [self.view layoutIfNeeded];
          }
          completion:^(BOOL finished) {
            _lblHoodHeaderTitle.hidden = YES;
            _lblHeaderTitle.hidden = YES;
          }];
    }
  }
}
- (IBAction)closePressed:(id)sender {
  APPDelegate.tabBarController.customTabbar.hidden = NO;
  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)postPressed:(id)sender {
  [self.view endEditing:YES];
  if (_txtComment.text.length > 0) {
    [ServiceManager
        InsertCommentFor:ServiceManager.loggedUser
             commentText:_txtComment.text
                ForEvent:_event
            onCompletion:^(BOOL success) {
              if (success) {
                _txtComment.text = @"";
                [self showAlertWithMessage:@"Your comment was successful!"];
                [ServiceManager getEventCommentsForEvent:_event.eventId
                                            onCompletion:^(BOOL success,
                                                           NSArray *comments) {
                                              if (success) {
                                                _event.arrComments = comments;
                                                [_iblEventDetail reloadData];
                                              }
                                            }];
              }
            }];
  }
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  NSString *text = [textField.text stringByReplacingCharactersInRange:range
                                                           withString:string];
  return text.length <= 800;
}

@end
