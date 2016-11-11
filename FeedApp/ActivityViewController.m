//
//  ActivityViewController.m
//  FeedApp
//
//  Created by TechLoverr on 25/10/16.
//
//

#import "ActivityViewController.h"
#import "FeedDetailViewController.h"
#import "FeedsTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface ActivityViewController () <
    UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource> {
  NSArray *arrData;
  NSInteger selectedIndex;
}
@property(weak, nonatomic) IBOutlet UITableView *tblView;
@property(weak, nonatomic) IBOutlet UILabel *lblHeader;
@property(assign, nonatomic) NSInteger pageNumber;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tblView.estimatedRowHeight = 200;
  _tblView.rowHeight = UITableViewAutomaticDimension;
  _tblView.allowsSelection = NO;
  _tblView.delegate = self;
  _tblView.dataSource = self;
  _tblView.emptyDataSetSource = self;
  ServiceManager.selectedSections = [ServiceManager.sections copy];

  if (_user.userID == ServiceManager.loggedUser.userID) {
    _lblHeader.text = @"My Activity";
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [APPDelegate startLoadingView];
  [ServiceManager
      getUserTimelinePostsForSections:[[ServiceManager.selectedSections valueForKey:@"ID"]
                                          componentsJoinedByString:@","]
                            ForHoodId:_user.hoodId
                        ForPageNumber:0
                            ForUserId:_user.userID
                         OnCompletion:^(BOOL success, NSArray *posts) {
                           [APPDelegate stopLoadingView];
                           if (success) {
                             arrData = posts;
                             [_tblView reloadData];
                           }
                         }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  selectedIndex = -1;
  [_tblView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
  CGPoint offset = aScrollView.contentOffset;
  CGRect bounds = aScrollView.bounds;
  CGSize size = aScrollView.contentSize;
  UIEdgeInsets inset = aScrollView.contentInset;
  float y = offset.y + bounds.size.height - inset.bottom;
  float h = size.height;

  float reload_distance = 10;
  if (y > h + reload_distance) {

    if (_pageNumber == -1) {
      return;
    }

    _pageNumber++;

    [ServiceManager
        getUserTimelinePostsForSections:[[ServiceManager.selectedSections valueForKey:@"ID"]
                                            componentsJoinedByString:@","]
                              ForHoodId:_user.hoodId
                          ForPageNumber:_pageNumber
                              ForUserId:_user.userID
                           OnCompletion:^(BOOL success, NSArray *posts) {
                             [APPDelegate stopLoadingView];
                             if (success) {
                               arrData = [arrData
                                   arrayByAddingObjectsFromArray:posts];

                               if (posts.count == 0) {
                                 _pageNumber = -1;
                               }
                               [_tblView reloadData];
                             }

                           }];
  }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  FeedsTableViewCell *cell = (FeedsTableViewCell *)[tableView
      dequeueReusableCellWithIdentifier:@"Cell"];
  cell.containerView.layer.borderColor =
      [UIColor colorWithWhite:0.8 alpha:0.5].CGColor;
  cell.containerView.layer.masksToBounds = NO;
  cell.containerView.layer.shadowOffset = CGSizeMake(0, 2);
  cell.containerView.layer.shadowRadius = 1;
  cell.containerView.layer.shadowOpacity = 0.1;

  cell.btnArrowForReport.tag = indexPath.row;

  if (selectedIndex == indexPath.row) {
    if (cell.btnReport.hidden) {
      cell.btnReport.hidden = NO;
    } else {
      cell.btnReport.hidden = YES;
    }
  } else {
    cell.btnReport.hidden = YES;
  }

  cell.post = arrData[indexPath.row];
    cell.imgUser.layer.borderColor = [UIColor clearColor].CGColor;
  cell.replyHandler = ^{
    [self performSegueWithIdentifier:@"toReply" sender:arrData[indexPath.row]];
  };

    [cell.btnMoreReplies setTitle:[NSString stringWithFormat:@"%ld more replies", (long)cell.post.totalComments] forState:UIControlStateNormal];
    
  cell.moreReplyHandler = ^{
    [self performSegueWithIdentifier:@"toDetail" sender:arrData[indexPath.row]];
  };

  return cell;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
  return [UIImage imageNamed:@"no_content"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;
{
  return [[NSAttributedString alloc]
      initWithString:@"\"Be the first one to start your "
                     @"neighbour\"Hood\"\nconnect. Create a Post to Connect / "
                     @"Share /\nSeek Help from Fellow Hooders\""
          attributes:@{
            NSFontAttributeName : FONT_DEFAULT_REGULAR(13),
            NSForegroundColorAttributeName : UIColorFromRGB(0x2276B8)
          }];
}
- (IBAction)closePressed:(id)sender {
  [self dismissViewControllerAnimated:YES
                           completion:^{

                           }];
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
