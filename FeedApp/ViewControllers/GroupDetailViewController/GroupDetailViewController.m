//
//  GroupDetailViewController.m
//  FeedApp
//
//  Created by TechLoverr on 18/09/16.
//
//

#import "CreatePostViewController.h"
#import "FeedDetailViewController.h"
#import "FeedsTableViewCell.h"
#import "GroupDetailHeaderTableViewCell.h"
#import "GroupDetailViewController.h"
#import "LLHeaderLabel.h"
#import "ParallaxHeaderView.h"

@interface GroupDetailViewController () <
UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    BOOL shouldReply;
}
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *topHeaderConstraint;
@property(weak, nonatomic) IBOutlet LLLabel *lblHeaderTitle;
@property(weak, nonatomic) IBOutlet UILabel *lblHoodTitle;
@property(weak, nonatomic) IBOutlet UITableView *tblGroupDetail;
@property(weak, nonatomic) IBOutlet LLHeaderLabel *lblTitle;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;
@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNumber = 0;
    ParallaxHeaderView *headerView = [ParallaxHeaderView
                                      parallaxHeaderViewWithImage:[UIImage imageNamed:@"group_default"]
                                      forSize:CGSizeMake(SCREEN_WIDTH, 175)];
    
    [headerView.imageView
     sd_setImageWithURL:[NSURL URLWithString:_group.groupCoverPhoto]
     placeholderImage:[UIImage imageNamed:@"group_default"]];
    
    _tblGroupDetail.estimatedRowHeight = 100;
    _tblGroupDetail.rowHeight = UITableViewAutomaticDimension;
    _tblGroupDetail.delegate = self;
    _tblGroupDetail.dataSource = self;
    _tblGroupDetail.tableHeaderView = headerView;
    APPDelegate.tabBarController.customTabbar.hidden = YES;
    _labelHeightConstraint.constant = 175;
    _lblHeaderTitle.text = _group.groupName.uppercaseString;
    _lblHoodTitle.text = _group.section.name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    APPDelegate.tabBarController.customTabbar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view sendSubviewToBack:_tblGroupDetail];
    _btnPost.hidden = YES;
    if (_group.userJoined) {
        self.view.userInteractionEnabled = NO;
        _btnPost.hidden = NO;
        [ServiceManager
         getGroupTimelinePostsForGroupId:_group.groupId
         ForPageNumber:0
         OnCompletion:^(BOOL success, NSArray *posts) {
             self.view.userInteractionEnabled = YES;
             [APPDelegate stopLoadingView];
             if (success) {
                 _posts = posts;
                 [_tblGroupDetail reloadData];
             }
         }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 1 + _posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0) {
        FeedsTableViewCell *cell = (FeedsTableViewCell *)[tableView
                                                          dequeueReusableCellWithIdentifier:@"Cell"];
        cell.containerView.layer.borderColor =
        [UIColor colorWithWhite:0.8 alpha:0.5].CGColor;
        cell.containerView.layer.masksToBounds = NO;
        cell.containerView.layer.shadowOffset = CGSizeMake(0, 2);
        cell.containerView.layer.shadowRadius = 1;
        cell.containerView.layer.shadowOpacity = 0.1;
        cell.post = _posts[indexPath.row - 1];
        
        cell.replyHandler = ^{
            shouldReply = YES;
            [self performSegueWithIdentifier:@"toDetail"
                                      sender:_posts[indexPath.row - 1]];
        };
        
        cell.moreReplyHandler = ^{
            shouldReply = NO;
            [self performSegueWithIdentifier:@"toDetail"
                                      sender:_posts[indexPath.row - 1]];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        GroupDetailHeaderTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        cell.group = self.group;
        cell.reloadHandler = ^{
            _btnPost.hidden = !_group.userJoined;
            if (!_group.userJoined) {
                self.posts = @[];
                [self.tblGroupDetail reloadData];
            } else {
                [self viewDidAppear:YES];
            }
        };
        return cell;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        FeedDetailViewController *vc = segue.destinationViewController;
        vc.shouldStartEditing = shouldReply;
        vc.post = sender;
        vc.group = _group;
    } else if ([segue.destinationViewController
                isKindOfClass:[CreatePostViewController class]]) {
        CreatePostViewController *vc = segue.destinationViewController;
        vc.section = _group.section;
        vc.group = _group;
    }
}

- (IBAction)closePressed:(id)sender {
    APPDelegate.tabBarController.customTabbar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _tblGroupDetail) {
        [((ParallaxHeaderView *)_tblGroupDetail.tableHeaderView)
         layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
        _labelHeightConstraint.constant = (175 - scrollView.contentOffset.y > 44)
        ? 175 - scrollView.contentOffset.y
        : 44;
        _lblTitle.alpha = 1 / _tblGroupDetail.tableHeaderView.frame.size.height *
        (scrollView.contentOffset.y > 125 ? 2 : 1) *
        scrollView.contentOffset.y;
        
        if (_lblTitle.alpha > 1) {
            _lblHoodTitle.hidden = NO;
            _lblHeaderTitle.hidden = NO;
            _topHeaderConstraint.constant = 8;
            [UIView animateWithDuration:0.2
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }];
        } else {
            
            _topHeaderConstraint.constant = 40;
            [UIView animateWithDuration:0.2
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
                                 _lblHoodTitle.hidden = YES;
                                 _lblHeaderTitle.hidden = YES;
                             }];
        }
        
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        // NSLog(@"offset: %f", offset.y);
        // NSLog(@"content.height: %f", size.height);
        // NSLog(@"bounds.height: %f", bounds.size.height);
        // NSLog(@"inset.top: %f", inset.top);
        // NSLog(@"inset.bottom: %f", inset.bottom);
        // NSLog(@"pos: %f of %f", y, h);
        
        float reload_distance = 10;
        if (y > h + reload_distance && _pageNumber != -1 && _group.userJoined) {
            
            [ServiceManager
             getGroupTimelinePostsForGroupId:_group.groupId
             ForPageNumber:_pageNumber + 1
             OnCompletion:^(BOOL success, NSArray *posts) {
                 [APPDelegate stopLoadingView];
                 
                 if (success) {
                     
                     _pageNumber++;
                     
                     if (posts.count == 0) {
                         _pageNumber = -1;
                     }
                     _posts = [_posts
                               arrayByAddingObjectsFromArray:posts];
                     [_tblGroupDetail reloadData];
                 }
             }];
        }
    }
}

@end
