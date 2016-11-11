//
//  EventsViewController.m
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import "EventDetailViewController.h"
#import "EventTableViewCell.h"
#import "EventsViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface EventsViewController () <UITableViewDataSource, UITableViewDelegate,
                                    DZNEmptyDataSetSource> {
  NSArray *createdEvents;
  NSArray *joinedEvents;
}
@property(weak, nonatomic) IBOutlet UILabel *lblHeader;
@property(weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation EventsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _tblView.estimatedRowHeight = 50;
  _tblView.rowHeight = UITableViewAutomaticDimension;
  _tblView.delegate = self;
  _tblView.dataSource = self;
  _tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tblView.emptyDataSetSource = self;

  _lblHeader.text =
      _userId == ServiceManager.loggedUser.userID ? @"My Events" : @"Events";
  _btnCreate.hidden = _userId != ServiceManager.loggedUser.userID;

  
}

- (void)viewWillAppear:(BOOL)animated {
    [APPDelegate startLoadingView];
    _tblView.hidden = YES;
  [ServiceManager getEventsForUser:[_userId integerValue]
                      onCompletion:^(BOOL success, NSArray *groups) {
                          if (success) {
                              
                              createdEvents = groups;
                              [_tblView reloadData];
                              _tblView.hidden = NO;
                              
                              [ServiceManager getInterestedEventsForUser:[_userId integerValue] onCompletion:^(BOOL success, NSArray *groups) {
                                  [APPDelegate stopLoadingView];
                                  if (success) {
                                      joinedEvents = groups;
                                      [_tblView reloadData];
                                  }
                              }];
                              
                          }else{
                              _tblView.hidden = NO;
                              [APPDelegate stopLoadingView];
                          }
                      }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  switch (section) {
  case 0:
    return createdEvents.count;
    break;
  case 1:
    return joinedEvents.count;
    break;

  default:
    break;
  }

  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  switch (section) {
  case 0:
    return createdEvents.count ? 40 : 0;
    break;
  case 1:
    return joinedEvents.count ? 40 : 0;
    break;

  default:
    break;
  }

  return 0;
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
    if (createdEvents.count) {
      lblHeader.text = _userId == ServiceManager.loggedUser.userID
                           ? @"My Created Events"
                           : @"Created Events";
    }
    break;
  case 1:
    if (joinedEvents.count) {
      lblHeader.text = _userId == ServiceManager.loggedUser.userID
                           ? @"My Interested Events"
                           : @"Interested Events";
    }

    break;
  default:
    break;
  }

  return lblHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  EventTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"EventCell"];

  LLEvent *event = indexPath.section ? joinedEvents[indexPath.row]
                                     : createdEvents[indexPath.row];

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
  LLEvent *event = indexPath.section ? joinedEvents[indexPath.row]
                                     : createdEvents[indexPath.row];
  [self performSegueWithIdentifier:@"toDetail" sender:event];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
  return [UIImage imageNamed:@"no_event"];
}
- (IBAction)closePressed:(id)sender {
  [self dismissViewControllerAnimated:YES
                           completion:^{

                           }];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;
{
  return [[NSAttributedString alloc]
      initWithString:_userId == ServiceManager.loggedUser.userID
                         ? @"No Events Found!"
                         : @"Hooder is not interested in any Event currently"
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
    EventDetailViewController *gVC = segue.destinationViewController;
    gVC.event = sender;
  }
}
@end
