//
//  RecommendationsViewController.m
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import "FeedDetailViewController.h"
#import "FeedsTableViewCell.h"
#import "RecommendationsViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface RecommendationsViewController () <
    UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource> {
  NSArray *arrData;
  NSInteger selectedIndex;
  UIRefreshControl *refreshControl;
}
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(assign, nonatomic) NSInteger pageNumber;
@end

@implementation RecommendationsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.estimatedRowHeight = 200;
  _tableView.rowHeight = UITableViewAutomaticDimension;
  _tableView.allowsSelection = NO;
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.emptyDataSetSource = self;

  self.selectionHandler = ^{
    _pageNumber = 0;
    [APPDelegate startLoadingView];
    [ServiceManager
        getRecommendationPostsForSections:[[ServiceManager.selectedSections valueForKey:@"ID"]
                                              componentsJoinedByString:@","]
                                ForHoodId:ServiceManager.selctedHood.ID
                            ForPageNumber:_pageNumber
                             OnCompletion:^(BOOL success, NSArray *posts) {
                               [APPDelegate stopLoadingView];

                               if (success) {
                                 arrData = posts;
                                 [_tableView reloadData];
                               }
                             }];
  };

  refreshControl = [[UIRefreshControl alloc] init];

  [refreshControl addTarget:self
                     action:@selector(refreshPressed)
           forControlEvents:UIControlEventValueChanged];

  [self.tableView addSubview:refreshControl];
}

- (void)refreshPressed {
  _pageNumber = 0;
  [ServiceManager
      getRecommendationPostsForSections:[[ServiceManager.selectedSections valueForKey:@"ID"]
                                            componentsJoinedByString:@","]
                              ForHoodId:ServiceManager.selctedHood.ID
                          ForPageNumber:_pageNumber
                           OnCompletion:^(BOOL success, NSArray *posts) {
                             [APPDelegate stopLoadingView];
                             [refreshControl endRefreshing];
                             if (success) {
                               arrData = posts;
                               [_tableView reloadData];
                             }
                           }];
}

- (void)viewWillAppear:(BOOL)animated {

  APPDelegate.tabBarController.customTabbar.hidden = NO;
  _pageNumber = 0;

  [APPDelegate startLoadingView];
  [ServiceManager
      getRecommendationPostsForSections:[[ServiceManager.selectedSections valueForKey:@"ID"]
                                            componentsJoinedByString:@","]
                              ForHoodId:ServiceManager.selctedHood.ID
                          ForPageNumber:_pageNumber
                           OnCompletion:^(BOOL success, NSArray *posts) {
                             [APPDelegate stopLoadingView];
                             [super viewWillAppear:animated];
                             if (success) {
                               arrData = posts;
                               [_tableView reloadData];
                             }
                           }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  selectedIndex = -1;
  [_tableView reloadData];
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
        getRecommendationPostsForSections:[ServiceManager.selectedSections valueForKey:@"ID"]
                                ForHoodId:ServiceManager.selctedHood.ID
                            ForPageNumber:_pageNumber
                             OnCompletion:^(BOOL success, NSArray *posts) {
                               [APPDelegate stopLoadingView];

                               if (success) {
                                 arrData = [arrData
                                     arrayByAddingObjectsFromArray:posts];

                                 if (posts.count == 0) {
                                   _pageNumber = -1;
                                 }

                                 [_tableView reloadData];
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

  //  if (indexPath.row == 1) {
  //    UITableViewCell *cell =
  //        [tableView dequeueReusableCellWithIdentifier:@"NewHooderCell"];
  //    if (cell != nil) {
  //      return cell;
  //    }
  //  }
  //
  //  if (indexPath.row == 3) {
  //    UITableViewCell *cell =
  //        [tableView dequeueReusableCellWithIdentifier:@"NewEventCell"];
  //
  //    if (cell != nil) {
  //      return cell;
  //    }
  //  }

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

  cell.replyHandler = ^{

  };

  [cell.btnMoreReplies setTitle:[NSString stringWithFormat:@"%ld more replies", (long)cell.post.totalComments] forState:UIControlStateNormal];
    
  cell.moreReplyHandler = ^{
    [self performSegueWithIdentifier:@"toDetail" sender:arrData[indexPath.row]];
  };

  return cell;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
  return [UIImage imageNamed:@"No_recommendation"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"toReply"] ||
      [segue.identifier isEqual:@"toDetail"]) {
    FeedDetailViewController *vc = segue.destinationViewController;
    vc.shouldStartEditing = [segue.identifier isEqual:@"toReply"];
    vc.post = sender;
  }
}

@end
