//
//  GroupListingViewController.m
//  FeedApp
//
//  Created by TechLoverr on 14/09/16.
//
//

#import "GroupDetailViewController.h"
#import "GroupListingViewController.h"
#import "GroupTableViewCell.h"
#import "LLLabel.h"
#import <ActionSheetPicker.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface GroupListingViewController () <
    UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource> {
  NSArray *arrData;
  UIRefreshControl *refreshControl;
}
@property(weak, nonatomic) IBOutlet UITableView *tblGroups;
@property(weak, nonatomic) IBOutlet LLLabel *lblFilterBy;
@property (weak, nonatomic) IBOutlet UIButton *btnGroup;
@property(weak, nonatomic) LLSection *selectedSection;
@end

@implementation GroupListingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _tblGroups.estimatedRowHeight = 50;
  _tblGroups.rowHeight = UITableViewAutomaticDimension;
  _tblGroups.delegate = self;
  _tblGroups.dataSource = self;
  _tblGroups.emptyDataSetSource = self;

  refreshControl = [[UIRefreshControl alloc] init];

  [refreshControl addTarget:self
                     action:@selector(refreshPressed)
           forControlEvents:UIControlEventValueChanged];

  [_tblGroups addSubview:refreshControl];
}

- (void)refreshPressed {
  [ServiceManager
      getGroupsForUserId:ServiceManager.loggedUser.userID
              WithHoodId:ServiceManager.selctedHood.ID
            onCompletion:^(BOOL success, NSArray *groups) {
              [APPDelegate stopLoadingView];
              [refreshControl endRefreshing];
              if (success) {
                arrData = [groups sortedArrayUsingDescriptors:@[
                  [NSSortDescriptor sortDescriptorWithKey:@"createdOn"
                                                ascending:NO]
                ]];
                [_tblGroups reloadData];
              }
            }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [APPDelegate startLoadingView];
  [ServiceManager
      getGroupsForUserId:ServiceManager.loggedUser.userID
              WithHoodId:ServiceManager.selctedHood.ID
            onCompletion:^(BOOL success, NSArray *groups) {
              [APPDelegate stopLoadingView];

              if (success) {
                arrData = [groups sortedArrayUsingDescriptors:@[
                  [NSSortDescriptor sortDescriptorWithKey:@"createdOn"
                                                ascending:NO]
                ]];
                [_tblGroups reloadData];
              }
            }];
    
    _btnGroup.hidden = ServiceManager.selctedHood.ID != ServiceManager.loggedUser.hoodId;
}

- (NSArray *)getFilteredData {
  if (_selectedSection == nil) {
    return arrData;
  } else {
    return [arrData
        filteredArrayUsingPredicate:[NSPredicate
                                        predicateWithFormat:@"section = %@",
                                                            _selectedSection]];
  }
}

- (IBAction)filterPressed:(id)sender {
  NSMutableArray *arrCatList = [NSMutableArray new];
  [arrCatList addObject:@"All"];
  [arrCatList
      addObjectsFromArray:[ServiceManager.sections valueForKey:@"name"]];

  [ActionSheetStringPicker
      showPickerWithTitle:@"Filter By"
                     rows:arrCatList
         initialSelection:0
                doneBlock:^(ActionSheetStringPicker *picker,
                            NSInteger selectedIndex, id selectedValue) {
                  _lblFilterBy.text = selectedValue;
                  if (selectedIndex == 0) {
                    _selectedSection = nil;
                  } else {
                    _selectedSection =
                        ServiceManager.sections[selectedIndex - 1];
                  }

                  [_tblGroups reloadData];
                }
              cancelBlock:nil
                   origin:sender];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.getFilteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  GroupTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];

  LLGroup *group = self.getFilteredData[indexPath.row];

  [cell.imgView sd_setImageWithURL:[NSURL URLWithString:group.groupCoverPhoto]
                  placeholderImage:[UIImage imageNamed:@"group_default"]];

  cell.lblGroupName.text = group.groupName.uppercaseString;
  cell.lblSectionName.text = group.section.name;
  cell.lblHoodersCount.text =
      [@"Hooders " stringByAppendingFormat:@"%lu", group.hoodersCount];

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LLGroup *group = self.getFilteredData[indexPath.row];

  [APPDelegate startLoadingView];
  [ServiceManager
      getGroupDetailForGroup:group
                onCompletion:^(BOOL success, NSArray *_group) {
                  [APPDelegate stopLoadingView];
                  if (success) {
                    [self
                        performSegueWithIdentifier:@"toGroupDetail"
                                            sender:_group.firstObject ?: group];
                  }
                }];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
  return [UIImage imageNamed:@"no_Group"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;
{

  return [[NSAttributedString alloc]
      initWithString:_selectedSection
                         ? [@"There are no groups in this hood for "
                               stringByAppendingString:_selectedSection.name]
                         : @"No Groups Found!"
          attributes:@{
            NSFontAttributeName : FONT_DEFAULT_REGULAR(13),
            NSForegroundColorAttributeName : UIColorFromRGB(0x2276B8)
          }];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
  return 2;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"toGroupDetail"]) {
    GroupDetailViewController *gVC = segue.destinationViewController;
    gVC.group = sender;
  }
}

@end
