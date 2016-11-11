//
//  CategorySelectionViewController.m
//  FeedApp
//
//  Created by Vishal on 03/09/16.
//
//

#import "CategorySelectionViewController.h"
#import "CreatePostViewController.h"
#import "LLTabBarController.h"

#define kToCreatePost @"toCreatePost"

@interface CategorySelectionViewController () {
  NSArray *arrCatList;
}
@property(weak, nonatomic) IBOutlet UITableView *tblCategoryList;

@end

@implementation CategorySelectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _tblCategoryList.backgroundColor = [UIColor clearColor];
  _tblCategoryList.tableFooterView = [UIView new];

  arrCatList = ServiceManager.sections;
}

- (void)viewWillAppear:(BOOL)animated {
  [_tblCategoryList selectRowAtIndexPath:nil
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)actionBack:(id)sender {
  LLTabBarController *tabBarController = (id)self.tabBarController;
  [tabBarController selectViewControllerAtIndex:HOME];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:kToCreatePost
                            sender:[ServiceManager.sections
                                       objectAtIndex:indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 40;
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)sectionIndex {
  return arrCatList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"CellCatSelection";
  CustomCatCell *cell;
  cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (cell == nil) {
    cell = (CustomCatCell *)[[UITableViewCell alloc]
          initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:cellIdentifier];
  }
  cell.lblTitle.text = [[arrCatList objectAtIndex:indexPath.row] name];
  cell.lblTitle.highlightedTextColor = [UIColor whiteColor];
  UIView *selectionColor = [[UIView alloc] init];
  selectionColor.backgroundColor = THEME_BLUE_COLOR;
  cell.selectedBackgroundView = selectionColor;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kToCreatePost]) {
    [_tblCategoryList selectRowAtIndexPath:nil
                                  animated:NO
                            scrollPosition:UITableViewScrollPositionNone];
    CreatePostViewController *vc = segue.destinationViewController;
    vc.section = sender;
  }
}

@end

@implementation CustomCatCell

@end