//
//  UserSettingViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "LoginViewController.h"
#import "TutorialViewController.h"
#import "UserSettingViewController.h"

#define kAccountDetailSegue @"toAccountDetails"
#define kSetPasswordSegue @"toSetPassword"
#define kNotificationSegue @"toNotificationSettings"
#define kCategorySegue @"toCategorySelection"

@interface UserSettingViewController () <UITableViewDelegate,
                                         UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *tblSettings;
@property(strong, nonatomic) NSArray *arrSettings;
@end

@implementation UserSettingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _arrSettings = @[
    @"Account Details",
    @"Change Password",
    @"Notifications",
    @"Categories of Interest",
    @"Logout"
  ];
  _tblSettings.delegate = self;
  _tblSettings.dataSource = self;
  _tblSettings.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
  APPDelegate.tabBarController.customTabbar.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return _arrSettings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UserSettings *cell =
      [tableView dequeueReusableCellWithIdentifier:@"CellUserSettings"];
  cell.lblName.text = _arrSettings[indexPath.row];
  cell.accessoryView = [[UIImageView alloc]
      initWithImage:[UIImage imageNamed:@"user_setting-back"]];
  cell.dividerView.hidden = indexPath.row == 4;
  return cell;
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
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  if (indexPath.row == 0) {
    [self performSegueWithIdentifier:kAccountDetailSegue sender:nil];
  } else if (indexPath.row == 1) {
    [self performSegueWithIdentifier:kSetPasswordSegue sender:nil];
  } else if (indexPath.row == 2) {
    [self performSegueWithIdentifier:kNotificationSegue sender:nil];
  } else if (indexPath.row == 3) {
    [self performSegueWithIdentifier:kCategorySegue sender:nil];
  } else {
    UIViewController *vc =
        [[APPDelegate.tabBarController.navigationController.viewControllers
            filteredArrayUsingPredicate:
                [NSPredicate
                    predicateWithFormat:@"class = %@",
                                        [TutorialViewController class]]]
            firstObject];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [APPDelegate.tabBarController.navigationController popToViewController:vc
                                                                  animated:YES];
  }
}

- (IBAction)backPressed:(id)sender {
  APPDelegate.tabBarController.customTabbar.hidden = NO;
  [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation UserSettings

@end
