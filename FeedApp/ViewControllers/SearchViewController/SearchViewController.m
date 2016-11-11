//
//  SearchViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "EventDetailViewController.h"
#import "EventTableViewCell.h"
#import "FeedDetailViewController.h"
#import "GroupDetailViewController.h"
#import "GroupTableViewCell.h"
#import "HMSegmentedControl.h"
#import "PureLayout.h"
#import "SearchTableViewCell.h"
#import "SearchViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#define kFeedDetail @"toFeedDetail"
#define kEventDetail @"toEventDetail"
#define kGroupDetail @"toGroupDetail"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource,
                                    UITextFieldDelegate,
                                    DZNEmptyDataSetSource> {
  NSString *cellIdentifier;
  NSArray *arrPosts;
  NSArray *arrGroups;
  NSArray *arrEvents;
  NSArray *arrUsers;
  HMSegmentedControl *segmentedControl;
}
@property(weak, nonatomic) IBOutlet UITextField *txtSearch;
@property(weak, nonatomic) IBOutlet UIView *segmentedControlContainer;
@property(weak, nonatomic) IBOutlet UITableView *tblSearch;

@end

@implementation SearchViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  cellIdentifier = @"PostCell";
  _tblSearch.estimatedRowHeight = 100;
  _tblSearch.rowHeight = UITableViewAutomaticDimension;
  _tblSearch.delegate = self;
  _tblSearch.dataSource = self;
  _tblSearch.emptyDataSetSource = self;
  _tblSearch.hidden = YES;
  UIImageView *viewSearch = [[UIImageView alloc]
      initWithFrame:CGRectMake(0, 0, self.txtSearch.frame.size.height,
                               self.txtSearch.frame.size.height)];
  viewSearch.backgroundColor = [UIColor clearColor];
  viewSearch.image = [UIImage imageNamed:@"search"];
  viewSearch.contentMode = UIViewContentModeScaleAspectFit;

  _txtSearch.leftView = viewSearch;
  _txtSearch.textColor = [UIColor whiteColor];
  _txtSearch.leftViewMode = UITextFieldViewModeAlways;
  _txtSearch.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:_txtSearch.placeholder
          attributes:@{
            NSForegroundColorAttributeName :
                [[UIColor whiteColor] colorWithAlphaComponent:0.6],
            NSFontAttributeName : [UIFont systemFontOfSize:12]
          }];
  _txtSearch.delegate = self;

  segmentedControl = [[HMSegmentedControl alloc]
      initWithSectionTitles:@[ @"Posts", @"Events", @"Groups", @"Hooders" ]];
  segmentedControl.selectionStyle =
      HMSegmentedControlSelectionStyleFullWidthStripe;
  segmentedControl.selectionIndicatorLocation =
      HMSegmentedControlSelectionIndicatorLocationDown;
  [segmentedControl setTitleFormatter:^NSAttributedString *(
                        HMSegmentedControl *segmentedControl, NSString *title,
                        NSUInteger index, BOOL selected) {
    NSAttributedString *attString = [[NSAttributedString alloc]
        initWithString:title
            attributes:@{
              NSForegroundColorAttributeName :
                  selected ? [UIColor blackColor] : [UIColor lightGrayColor],
              NSFontAttributeName :
                  selected ? FONT_DEFAULT_MEDIUM(12) : FONT_DEFAULT_REGULAR(12)
            }];
    return attString;
  }];
  segmentedControl.selectionIndicatorHeight = 2;
  segmentedControl.selectionIndicatorColor = UIColorFromRGB(0x2276B8);
  ;
  [segmentedControl addTarget:self
                       action:@selector(segmentedControlChangedValue:)
             forControlEvents:UIControlEventValueChanged];
  [self.segmentedControlContainer addSubview:segmentedControl];
  [segmentedControl autoPinEdgesToSuperviewEdges];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(textDidChange)
             name:UITextFieldTextDidChangeNotification
           object:_txtSearch];

  [ServiceManager
      getGroupsForUserId:ServiceManager.loggedUser.userID
              WithHoodId:ServiceManager.selctedHood.ID
            onCompletion:^(BOOL success, NSArray *groups) {
              if (success) {
                arrGroups = [groups sortedArrayUsingDescriptors:@[
                  [NSSortDescriptor sortDescriptorWithKey:@"createdOn"
                                                ascending:NO]
                ]];
              }
              [_tblSearch reloadData];
                [APPDelegate stopLoadingView];
            }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)getFilteredDataForSection:(NSInteger)section {
  switch (section) {
  case 0:
    return arrPosts;
    break;

  case 1:
    return arrEvents;
    break;

  case 2:
    return [arrGroups
        filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat:@"groupName contains [c] %@",
                                             _txtSearch.text]];
    break;

  case 3:
    return arrUsers;
    break;

  default:
    return @[];
    break;
  }
}

- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)_segmentedControl {
  switch (segmentedControl.selectedSegmentIndex) {
  case 0:
    cellIdentifier = @"PostCell";
    break;
  case 1:
    cellIdentifier = @"EventCell";
    break;
  case 2:
    cellIdentifier = @"GroupCell";
    break;
  case 3:
    cellIdentifier = @"HooderCell";
    break;
  default:
    break;
  }
  _tblSearch.contentOffset = CGPointZero;
  [self searchData:_txtSearch.text];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self getFilteredDataForSection:segmentedControl.selectedSegmentIndex]
      .count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *arrData =
      [self getFilteredDataForSection:segmentedControl.selectedSegmentIndex];
  switch (segmentedControl.selectedSegmentIndex) {
  case 0: {
    cellIdentifier = @"PostCell";
    SearchTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.post = arrData[indexPath.row];
    return cell;
  } break;
  case 1: {
    cellIdentifier = @"EventCell";
    EventTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    LLEvent *event = [arrData objectAtIndex:indexPath.row];

    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:event.eventCoverPhoto]
                    placeholderImage:[UIImage imageNamed:@"eventPlaceholder"]];

    cell.lblEventName.text = event.eventName.uppercaseString;
    cell.lblSectionName.text = event.section.name;

    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"EEE, dd MMM";

    cell.lblDate.text = [df stringFromDate:event.startDate];

    return cell;
  } break;
  case 2: {
    GroupTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];

    LLGroup *group = arrData[indexPath.row];

    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:group.groupCoverPhoto]
                    placeholderImage:[UIImage imageNamed:@"group_default"]];

    cell.lblGroupName.text = group.groupName.uppercaseString;
    cell.lblSectionName.text = group.section.name;
    cell.lblHoodersCount.text =
        [@"Hooders " stringByAppendingFormat:@"%lu", group.hoodersCount];

    return cell;
  } break;
  case 3: {
    cellIdentifier = @"HooderCell";
    SearchTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.user = arrData[indexPath.row];
    return cell;
  } break;
  default:
    break;
  }

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

- (void)textDidChange {
  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        [self searchData:_txtSearch.text];
      });

  _tblSearch.hidden = _txtSearch.text.length == 0;
  _tblSearch.contentOffset = CGPointZero;
}

- (void)searchData:(NSString *)text {

  if (text != _txtSearch.text && text.length == 0) {
    return;
  }

  switch (segmentedControl.selectedSegmentIndex) {
      case 0:{
          arrPosts = [NSArray new];
          [APPDelegate startLoadingView];
          [ServiceManager getUserTimelinePostsForHoodId:ServiceManager.selctedHood.ID ForKeyword:text OnCompletion:^(BOOL success, NSArray *posts) {
              [APPDelegate stopLoadingView];
              if (success) {
                  arrPosts = [posts copy];
              }
              [_tblSearch reloadData];
          }];
      }
    break;
  case 1: {
      arrEvents = [NSArray new];
    [APPDelegate startLoadingView];
    [ServiceManager getEventsForKeyword:text
                             WithHoodId:ServiceManager.selctedHood.ID
                           onCompletion:^(BOOL success, NSArray *events) {
                             [APPDelegate stopLoadingView];
                             if (success) {
                               arrEvents = [events copy];
                             }
                             [_tblSearch reloadData];
                           }];
  } break;
  case 2:
    [_tblSearch reloadData];

    break;
  case 3: {
      arrUsers = [NSArray new];
    [APPDelegate startLoadingView];
    [ServiceManager searchHoodersForHood:ServiceManager.selctedHood.ID
                             WithKeyword:_txtSearch.text
                            onCompletion:^(BOOL success, NSArray *arrData) {
                              [APPDelegate stopLoadingView];
                              if (success) {
                                arrUsers = [arrData copy];
                              }
                              [_tblSearch reloadData];
                            }];
  } break;

  default:

    break;
  }
    
    [_tblSearch reloadData];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {

  switch (segmentedControl.selectedSegmentIndex) {
  case 0:
    return [UIImage imageNamed:@"no_post_search"];
    break;
  case 1:
    return [UIImage imageNamed:@"no_event_search"];
    break;
  case 2:
    return [UIImage imageNamed:@"no_group_search"];
    break;
  case 3:
    return [UIImage imageNamed:@"no_hooder_search"];
    break;

  default:
    return nil;
    break;
  }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.view endEditing:YES];
  NSArray *arrData =
      [self getFilteredDataForSection:segmentedControl.selectedSegmentIndex];
  switch (segmentedControl.selectedSegmentIndex) {
  case 0:
    [self performSegueWithIdentifier:kFeedDetail sender:arrData[indexPath.row]];
    break;
  case 2: {
    LLGroup *group = arrData[indexPath.row];

    [APPDelegate startLoadingView];
    [ServiceManager
        getGroupDetailForGroup:group
                  onCompletion:^(BOOL success, NSArray *_group) {
                    [APPDelegate stopLoadingView];
                    if (success) {
                      [self performSegueWithIdentifier:kGroupDetail
                                                sender:_group.firstObject
                                                           ?: group];
                    }
                  }];
  } break;
  case 1:
    [self performSegueWithIdentifier:kEventDetail
                              sender:arrData[indexPath.row]];
    break;
  case 3: {
    SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    [cell.imgUser imagePressed];
  } break;

  default:
    break;
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kFeedDetail]) {
    FeedDetailViewController *vc = segue.destinationViewController;

    vc.post = sender;
  }
  if ([segue.identifier isEqual:kGroupDetail]) {
    GroupDetailViewController *gVC = segue.destinationViewController;
    gVC.group = sender;
  }

  if ([segue.identifier isEqualToString:kEventDetail]) {
    EventDetailViewController *vc = segue.destinationViewController;
    vc.event = sender;
  }
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;
{
  NSString *text = @"";
  switch (segmentedControl.selectedSegmentIndex) {
  case 0:
    text = @"\"Couldn't find what you're looking for?\nCreate a new Post and "
           @"reach out to your fellow\nHooders\"";
    break;
  case 1:
    text = @"No Events Found!";
    break;
  case 2:
    text = @"\"Couldn't find the Group you were looking for?\nWhy not consider "
           @"creating a Group and\nstarting on your own";
    break;
  case 3:
    text = @"No Hooders Found!";
    break;

  default:
    break;
  }

  return [[NSAttributedString alloc]
      initWithString:text
          attributes:@{
            NSFontAttributeName : FONT_DEFAULT_REGULAR(13),
            NSForegroundColorAttributeName : UIColorFromRGB(0x2276B8)
          }];
};

@end
