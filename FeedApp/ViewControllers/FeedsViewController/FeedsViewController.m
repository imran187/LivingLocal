//
//  FeedsViewController.m
//  FeedApp
//
//  Created by TechLoverr on 03/09/16.
//
//

#import "CategorySelectionViewController.h"
#import "EventDetailViewController.h"
#import "FeedDetailViewController.h"
#import "FeedsTableView.h"
#import "FeedsViewController.h"
#import "GroupDetailViewController.h"

@interface FeedsViewController () {
  UIRefreshControl *refreshControl;
}
@property(nonatomic, copy) void (^animationDidEnd)(void);
@property(nonatomic, weak) UIView *destinationView;
@property(weak, nonatomic) IBOutlet UIButton *btnFilter;
@property(weak, nonatomic) IBOutlet FeedsTableView *tblFeeds;
@property(assign, nonatomic) NSInteger pageNumber;

@end

@implementation FeedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:_btnFilter];
    
    [APPDelegate startLoadingView];
    NSArray *arrData =
    [ServiceManager.loggedUser.interests componentsSeparatedByString:@","];
    NSMutableArray *arrSections = [NSMutableArray new];
    for (NSString *num in arrData) {
        if (num.length && [num integerValue]) {
            [arrSections addObject:[LLSection getSection:[num integerValue]]];
        }
    }
    
    ServiceManager.selectedSections = [arrSections mutableCopy];
    _tblFeeds.moreRowsHandler = ^{
        
        if (_pageNumber == -1) {
            return;
        }
        
        _pageNumber++;
        
        if (_user) {
            [ServiceManager
             getUserTimelinePostsForSections:ServiceManager.loggedUser.interests
             ForHoodId:_user.hoodId
             ForPageNumber:_pageNumber
             ForUserId:_user.userID
             OnCompletion:^(BOOL success, NSArray *posts) {
                 [APPDelegate stopLoadingView];
                 if (success) {
                     _tblFeeds.arrFeeds = [_tblFeeds.arrFeeds
                                           arrayByAddingObjectsFromArray:posts];
                     
                     if (posts.count == 0) {
                         _pageNumber = -1;
                     }
                     [_tblFeeds reloadData];
                 }
                 
             }];
        } else {
            [ServiceManager
             getTimelinePostsForSections:ServiceManager.loggedUser.interests
             ForHoodId:_hood
             ForPageNumber:_pageNumber
             OnCompletion:^(BOOL success, NSArray *posts) {
                 [APPDelegate stopLoadingView];
                 if (success) {
                     _tblFeeds.arrFeeds = [_tblFeeds.arrFeeds
                                           arrayByAddingObjectsFromArray:posts];
                     
                     if (posts.count == 0) {
                         _pageNumber = -1;
                     }
                     [_tblFeeds reloadData];
                 }
                 
             }];
        }
    };
    
    self.selectionHandler = ^{
        _pageNumber = 0;
        if (_user) {
            [ServiceManager
             getUserTimelinePostsForSections:ServiceManager.loggedUser.interests
             ForHoodId:_user.hoodId
             ForPageNumber:_pageNumber
             ForUserId:_user.userID
             OnCompletion:^(BOOL success, NSArray *posts) {
                 [APPDelegate stopLoadingView];
                 if (success) {
                     _tblFeeds.arrFeeds = posts;
                     [_tblFeeds reloadData];
                 }
             }];
        } else {
            [ServiceManager
             getTimelinePostsForSections:[[ServiceManager.selectedSections valueForKey:@"ID"]
                                          componentsJoinedByString:@","]
             ForHoodId:_hood
             ForPageNumber:_pageNumber
             OnCompletion:^(BOOL success, NSArray *posts) {
                 
                 if (success) {
                     _tblFeeds.arrFeeds = posts;
                     [_tblFeeds reloadData];
                 }
                 
             }];
        }
    };
    
    _tblFeeds.replyHandler = ^(LLPost *post) {
        [self performSegueWithIdentifier:@"toReply" sender:post];
    };
    
    _tblFeeds.moreReplyHandler = ^(LLPost *post) {
        [self performSegueWithIdentifier:@"toDetail" sender:post];
    };
    
    _tblFeeds.selectionHandler = ^(LLPost *post) {
        if (post.contentType == 5) {
            [APPDelegate startLoadingView];
            [ServiceManager
             getEvent:post.favouriteUserId
             onCompletion:^(BOOL success, LLEvent *event) {
                 [APPDelegate stopLoadingView];
                 if (success) {
                     [self performSegueWithIdentifier:@"toEventDetail" sender:event];
                 }
             }];
        } else {
            [APPDelegate startLoadingView];
            LLGroup *grp = [LLGroup new];
            grp.groupId = post.favouriteUserId;
            [ServiceManager
             getGroupDetailForGroup:grp
             onCompletion:^(BOOL success, NSArray *group) {
                 [APPDelegate stopLoadingView];
                 if (success) {
                     [self performSegueWithIdentifier:@"toGroupDetail"
                                               sender:group.firstObject];
                 }
             }];
        }
    };
    
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(refreshPressed)
             forControlEvents:UIControlEventValueChanged];
    
    [self.tblFeeds addSubview:refreshControl];
}

- (void)refreshPressed {
  _pageNumber = 0;
  [ServiceManager
      getTimelinePostsForSections:ServiceManager.loggedUser.interests
                        ForHoodId:_hood
                    ForPageNumber:0
                     OnCompletion:^(BOOL success, NSArray *posts) {
                       [APPDelegate stopLoadingView];
                       [refreshControl endRefreshing];
                       if (success) {
                         _tblFeeds.arrFeeds = posts;
                       }
                     }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  APPDelegate.tabBarController.customTabbar.hidden = NO;
  _pageNumber = 0;

  _hood = ServiceManager.selctedHood.ID;
  [APPDelegate startLoadingView];
  self.lblHood.text = [LLHood getHood:_hood].name;
  [ServiceManager
      getTimelinePostsForSections:ServiceManager.loggedUser.interests
                        ForHoodId:_hood
                    ForPageNumber:0
                     OnCompletion:^(BOOL success, NSArray *posts) {

                       [APPDelegate stopLoadingView];
                       if (success) {
                         _tblFeeds.arrFeeds = posts;
                       }
                     }];
}

- (IBAction)replyPressed:(id)sender {
  [self performSegueWithIdentifier:@"toReply" sender:nil];
}

- (void)showLeftMenuPressed:(id)sender {
  if (self.tabBarController) {
    [super showLeftMenuPressed:sender];
  } else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"toReply"] ||
      [segue.identifier isEqual:@"toDetail"]) {
    FeedDetailViewController *vc = segue.destinationViewController;
    vc.shouldStartEditing = [segue.identifier isEqual:@"toReply"];
    vc.post = sender;
  } else if ([segue.identifier isEqualToString:@"toEventDetail"]) {
    EventDetailViewController *evc = segue.destinationViewController;
    evc.event = sender;
  } else if ([segue.identifier isEqualToString:@"toGroupDetail"]) {
    GroupDetailViewController *evc = segue.destinationViewController;
    evc.group = sender;
  }
}

@end
