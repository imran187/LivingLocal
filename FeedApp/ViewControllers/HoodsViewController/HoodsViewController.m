//
//  HoodsViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "FeedsViewController.h"
#import "HoodsViewController.h"

@interface HoodsViewController () <UITableViewDelegate, UITableViewDataSource> {
  NSArray *arrData;
}
@property(weak, nonatomic) IBOutlet UITableView *tblHoods;

@end

@implementation HoodsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  arrData = [ServiceManager.hoods sortedArrayUsingDescriptors:@[
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]
  ]];
  _tblHoods.tableFooterView = [UIView new];
  _tblHoods.delegate = self;
  _tblHoods.dataSource = self;
  // Do any additional setup after loading the view.
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
  UIView *selectionColor = [[UIView alloc] init];
  selectionColor.backgroundColor = THEME_BLUE_COLOR;
  cell.selectedBackgroundView = selectionColor;
  cell.textLabel.highlightedTextColor = [UIColor whiteColor];
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

  ServiceManager.selctedHood = arrData[indexPath.row];

  [self dismissViewControllerAnimated:YES
                           completion:^{
                             [APPDelegate.tabBarController
                                 selectViewControllerAtIndex:0];
                             [APPDelegate.tabBarController.customTabbar
                                 selectItemAtIndex:TabBarItemTypeHome];
                           }];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                 dispatch_get_main_queue(), ^{
                   [tableView deselectRowAtIndexPath:indexPath animated:YES];
                 });
}

- (IBAction)closePressed:(id)sender {
  [self dismissViewControllerAnimated:YES
                           completion:^{

                           }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"toFeeds"]) {
    FeedsViewController *vc = segue.destinationViewController;
    vc.hood = ((LLHood *)sender).ID;
  }
}

@end
