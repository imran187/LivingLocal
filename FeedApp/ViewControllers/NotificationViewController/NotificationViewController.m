//
//  NotificationViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "FeedDetailViewController.h"
#import "NotificationTableViewCell.h"
#import "NotificationViewController.h"

@interface NotificationViewController () <UITableViewDataSource,
                                          UITableViewDelegate> {
  NSMutableArray *notifications;
}
@property(weak, nonatomic) IBOutlet UITableView *tblNotifications;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [APPDelegate startLoadingView];
  [ServiceManager getNotificationsForUserId:ServiceManager.loggedUser.userID
                               OnCompletion:^(BOOL success, NSArray *posts) {
                                 [APPDelegate stopLoadingView];
                                 notifications = [posts mutableCopy];
                                 [_tblNotifications reloadData];
                               }];

  _tblNotifications.estimatedRowHeight = 100;
  _tblNotifications.rowHeight = UITableViewAutomaticDimension;
  _tblNotifications.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tblNotifications.delegate = self;
  _tblNotifications.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  APPDelegate.tabBarController.customTabbar.hidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LLNotification *notification = notifications[indexPath.row];
  NotificationTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"Cell"];

  [cell.imgUser sd_setImageWithURL:[NSURL URLWithString:notification.userPhoto]
                  placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];

  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"dd MMMM yyyy 'at' h:mm a";

  cell.lblTime.text = [df stringFromDate:notification.notificationDate];

  NSMutableAttributedString *attrNotification =
      [[NSMutableAttributedString alloc]
          initWithString:[NSString stringWithFormat:@"%@ %@ %@",
                                                    notification.firstName,
                                                    notification.lastName,
                                                    notification.notification]
              attributes:@{
                NSForegroundColorAttributeName : UIColorFromRGB(0x838383),
                NSFontAttributeName : cell.lblNotification.font
              }];

  [attrNotification
      addAttribute:NSForegroundColorAttributeName
             value:UIColorFromRGB(0x2276B8)
             range:[[NSString stringWithFormat:@"%@ %@ %@",
                                               notification.firstName,
                                               notification.lastName,
                                               notification.notification]
                       rangeOfString:
                           [NSString stringWithFormat:@"%@ %@",
                                                      notification.firstName,
                                                      notification.lastName]]];

  cell.lblNotification.attributedText = attrNotification;

  if (notification.isNotificationRead) {
    cell.backgroundColor = UIColorFromRGB(0xf1f1f2);
  } else {
    cell.backgroundColor = UIColorFromRGB(0xffffff);
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  LLNotification *notification = notifications[indexPath.row];
  LLPost *post = [LLPost new];
  post.ID = notification.contentId;

  if (notification.userNotificationType == 100) {
    [self performSegueWithIdentifier:@"toProfile" sender:nil];
  } else {
    [APPDelegate startLoadingView];
    [ServiceManager
        getPostDetail:post
         onCompletion:^(BOOL success, LLPost *post) {
           [APPDelegate stopLoadingView];
           if (success) {
             [self performSegueWithIdentifier:@"toDetail" sender:post];
           }
         }];
  }
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {

    [APPDelegate startLoadingView];
    [ServiceManager
        deleteNotification:[notifications objectAtIndex:indexPath.row]
              onCompletion:^(BOOL success) {
                [APPDelegate stopLoadingView];
                if (success) {
                  [notifications removeObjectAtIndex:indexPath.row];
                  [tableView
                      deleteRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
                }
              }];
  }
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  // Remove seperator inset
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }

  // Prevent the cell from inheriting the Table View's margin settings
  if ([cell
          respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    [cell setPreservesSuperviewLayoutMargins:NO];
  }

  // Explictly set your cell's layout margins
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
                   LLNotification *notification = notifications[indexPath.row];
                   if (!notification.isNotificationRead) {
                     [ServiceManager
                         markNotificationRead:notification.identifier
                                 onCompletion:^(BOOL success) {
                                   if (success) {
                                     notification.isNotificationRead = YES;
                                     [_tblNotifications reloadData];
                                   }
                                 }];
                   }
                 });
}

- (NSString *)tableView:(UITableView *)tableView
    titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
  return @"X\nDelete";
}

- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"toReply"] ||
      [segue.identifier isEqual:@"toDetail"]) {
    FeedDetailViewController *vc = segue.destinationViewController;
    vc.shouldStartEditing = [segue.identifier isEqual:@"toReply"];
    vc.post = sender;
  }
}

@end
