//
//  GroupsViewController.m
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import "GroupDetailViewController.h"
#import "GroupTableViewCell.h"
#import "GroupsViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface GroupsViewController () <UITableViewDataSource, UITableViewDelegate,
                                    DZNEmptyDataSetSource> {
  NSArray *arrData;
}
@property(weak, nonatomic) IBOutlet UILabel *lblHeader;
@property(weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation GroupsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _tblView.estimatedRowHeight = 50;
  _tblView.rowHeight = UITableViewAutomaticDimension;
  _tblView.delegate = self;
  _tblView.dataSource = self;
  _tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tblView.emptyDataSetSource = self;

  _lblHeader.text =
      _userId == ServiceManager.loggedUser.userID ? @"My Groups" : @"Groups";
  _btnCreate.hidden = _userId != ServiceManager.loggedUser.userID;
}

- (void)viewWillAppear:(BOOL)animated {
  [APPDelegate startLoadingView];
    _tblView.hidden = YES;
  [ServiceManager
      getGroupsForUserId:_userId
            onCompletion:^(BOOL success, NSArray *groups) {
              

              if (success) {
                arrData = [groups sortedArrayUsingDescriptors:@[
                  [NSSortDescriptor sortDescriptorWithKey:@"createdOn"
                                                ascending:NO]
                ]];
                [_tblView reloadData];
              }
                _tblView.hidden = NO;
                
                [APPDelegate stopLoadingView];
            }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSArray *)joinedGroups {
  return [arrData
      filteredArrayUsingPredicate:
          [NSPredicate predicateWithFormat:@"groupStatus = 'myJoined'"]];
}

- (NSArray *)createdGroups {
  return [arrData
      filteredArrayUsingPredicate:
          [NSPredicate predicateWithFormat:@"groupStatus = 'myCreated'"]];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  switch (section) {
  case 0:
          return [self createdGroups].count > 0 ? [self createdGroups].count : 1;
    break;
  case 1:
          return [self joinedGroups].count ? [self joinedGroups].count : 1;
    break;

  default:
    break;
  }

  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {

  return 40;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {

  UILabel *lblHeader =
      [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
  lblHeader.textAlignment = NSTextAlignmentCenter;
  lblHeader.font = FONT_DEFAULT_REGULAR(14);
  lblHeader.textColor = [UIColor darkGrayColor];
  lblHeader.backgroundColor = self.view.backgroundColor;
    switch (section) {
        case 0:
            
            lblHeader.text = _userId == ServiceManager.loggedUser.userID
            ? @"My Created Groups"
            : @"Created Groups";
            
            break;
        case 1:
            
            lblHeader.text = _userId == ServiceManager.loggedUser.userID
            ? @"My Joined Groups"
            : @"Joined Groups";
            
            break;
        default:
            break;
    }

  return lblHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *noGroupCell = [tableView dequeueReusableCellWithIdentifier:@"NoGroupCell"];
    switch (indexPath.section) {
        case 0:{
            if ([self createdGroups].count == 0) {
                noGroupCell.textLabel.text = @"No Groups Created";
                return noGroupCell;
            }
        }
            break;
        case 1:
        {
            if ([self joinedGroups].count == 0) {
                noGroupCell.textLabel.text = @"No Groups Joined";
                return noGroupCell;
            }
        }            break;
        default:
            break;
    }
    
  GroupTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];

  LLGroup *group = indexPath.section ? [self joinedGroups][indexPath.row]
                                     : [self createdGroups][indexPath.row];

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
  LLGroup *group = indexPath.section ? [self joinedGroups][indexPath.row]
                                     : [self createdGroups][indexPath.row];

  [APPDelegate startLoadingView];
  [ServiceManager
      getGroupDetailForGroup:group
                onCompletion:^(BOOL success, NSArray *_group) {
                  [APPDelegate stopLoadingView];
                  if (success) {
                    [self
                        performSegueWithIdentifier:@"toDetail"
                                            sender:_group.firstObject ?: group];
                  }
                }];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
  return [UIImage imageNamed:@"no_Group"];
}
- (IBAction)closePressed:(id)sender {
  [self dismissViewControllerAnimated:YES
                           completion:^{

                           }];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;
{
  return [[NSAttributedString alloc]
      initWithString:(_userId == ServiceManager.loggedUser.userID)
                         ? @"No Groups Found!"
                         : @"Hooder is not part of any Group currently"
          attributes:@{
            NSFontAttributeName : FONT_DEFAULT_REGULAR(13),
            NSForegroundColorAttributeName : UIColorFromRGB(0x2276B8)
          }];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
  return 2;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"toDetail"]) {
    GroupDetailViewController *gVC = segue.destinationViewController;
    gVC.group = sender;
  }
}

@end
