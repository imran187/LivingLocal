//
//  EventListingViewController.m
//  FeedApp
//
//  Created by TechLoverr on 18/09/16.
//
//

#import "EventDetailViewController.h"
#import "EventListingViewController.h"
#import "EventTableViewCell.h"
#import "LLLabel.h"
#import <ActionSheetPicker.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#define tomorrow 1
#define thisWeek 2
#define month 3
#define all 4

#define kEventDetail @"toEventDetail"

@interface EventListingViewController () <
    UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource> {
  NSArray *arrData;
  UIRefreshControl *refreshControl;
}
@property(weak, nonatomic) IBOutlet UITableView *tblEvents;
@property(weak, nonatomic) IBOutlet LLLabel *lblFilterBy;
@property(assign, nonatomic) NSInteger selctedFilter;

@end

@implementation EventListingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _selctedFilter = all;
  _tblEvents.estimatedRowHeight = 50;
  _tblEvents.rowHeight = UITableViewAutomaticDimension;
  _tblEvents.delegate = self;
  _tblEvents.dataSource = self;
  _tblEvents.emptyDataSetSource = self;

  refreshControl = [[UIRefreshControl alloc] init];

  [refreshControl addTarget:self
                     action:@selector(refreshPressed)
           forControlEvents:UIControlEventValueChanged];

  [_tblEvents addSubview:refreshControl];
}

- (void)refreshPressed {
  [ServiceManager getEventsForFilter:_selctedFilter
                          WithHoodId:ServiceManager.selctedHood.ID
                        onCompletion:^(BOOL success, NSArray *events) {
                          [APPDelegate stopLoadingView];
                          [refreshControl endRefreshing];
                          if (success) {
                            arrData = events;
                            [_tblEvents reloadData];
                          }
                        }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [APPDelegate startLoadingView];
  [ServiceManager getEventsForFilter:_selctedFilter
                          WithHoodId:ServiceManager.selctedHood.ID
                        onCompletion:^(BOOL success, NSArray *events) {
                          [APPDelegate stopLoadingView];
                          if (success) {
                            arrData = events;
                            [_tblEvents reloadData];
                          }
                        }];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return arrData.count;
}
- (IBAction)filterPressed:(id)sender {
  [ActionSheetStringPicker
      showPickerWithTitle:@"Filter By"
                     rows:@[
                       @"Tomorrow",
                       @"This Week",
                       @"This Month",
                       @"3 Months"
                     ]
         initialSelection:_selctedFilter - 1
                doneBlock:^(ActionSheetStringPicker *picker,
                            NSInteger selectedIndex, id selectedValue) {
                  _lblFilterBy.text = selectedValue;
                  _selctedFilter = selectedIndex + 1;
                  [APPDelegate startLoadingView];
                  [ServiceManager
                      getEventsForFilter:_selctedFilter
                              WithHoodId:ServiceManager.selctedHood.ID
                            onCompletion:^(BOOL success, NSArray *events) {
                              [APPDelegate stopLoadingView];
                              if (success) {
                                arrData = events;
                                [_tblEvents reloadData];
                              }
                            }];
                }
              cancelBlock:nil
                   origin:sender];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  EventTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"EventCell"];

  LLEvent *event = [arrData objectAtIndex:indexPath.row];

  [cell.imgView sd_setImageWithURL:[NSURL URLWithString:event.eventCoverPhoto]
                  placeholderImage:[UIImage imageNamed:@"eventPlaceholder"]];

  cell.lblEventName.text = event.eventName.uppercaseString;
  cell.lblSectionName.text = event.section.name;

  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"EEE, dd MMM";

  cell.lblDate.text = [df stringFromDate:event.startDate];

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LLEvent *event = [arrData objectAtIndex:indexPath.row];
  [self performSegueWithIdentifier:kEventDetail sender:event];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
  return [UIImage imageNamed:@"no_event"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;
{
  NSString *eventString = @"There are no events in the hood for 3 months";
  switch (_selctedFilter) {
  case 1:
    eventString = @"There are no events in the hood for tomorrow";
    break;
  case 2:
    eventString = @"There are no events in the hood for this week";
    break;
  case 3:
    eventString = @"There are no events in the hood for this month";
    break;

  default:
    break;
  }

  return [[NSAttributedString alloc]
      initWithString:eventString
          attributes:@{
            NSFontAttributeName : FONT_DEFAULT_REGULAR(13),
            NSForegroundColorAttributeName : UIColorFromRGB(0x2276B8)
          }];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
  return 2;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kEventDetail]) {
    EventDetailViewController *vc = segue.destinationViewController;
    vc.event = sender;
  }
}

@end
