//
//  SelectHoodViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "MobileNumberViewController.h"
#import "SelectHoodViewController.h"

#define kToMobileNumber @"toMobileNumber"

@interface SelectHoodViewController () <UITableViewDelegate,
                                        UITableViewDataSource> {
  NSArray *arrData;
}
@property(weak, nonatomic) IBOutlet UITableView *tblHoods;

@end

@implementation SelectHoodViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  arrData = ServiceManager.hoods;
  _tblHoods.tableFooterView = [UIView new];
  _tblHoods.delegate = self;
  _tblHoods.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  LLHood *hood = arrData[indexPath.row];
  cell.textLabel.text = hood.name;
  cell.textLabel.highlighted = _user.hoodName == hood.name;

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  LLHood *hood = arrData[indexPath.row];
  _user.hoodId = hood.ID;
  _user.cityID = hood.cityId;
  _user.hoodName = hood.name;
  cell.textLabel.highlighted = YES;
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.textLabel.highlighted = NO;
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
- (IBAction)claimPressed:(id)sender {
  if (_user.hoodName) {
    [APPDelegate startLoadingView];
    [ServiceManager
           signUpFor:_user
        onCompletion:^(BOOL success) {
          [APPDelegate stopLoadingView];
          if (success) {
            [self performSegueWithIdentifier:kToMobileNumber sender:nil];
          }
        }];
  } else {
    [self showAlertWithMessage:@"Please select hood"];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  MobileNumberViewController *vc = segue.destinationViewController;
  vc.user = _user;
}

@end
