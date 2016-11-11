//
//  TopHoodersViewController.m
//  FeedApp
//
//  Created by TechLoverr on 12/09/16.
//
//

#import "FSQCollectionViewAlignedLayout.h"
#import "HooderCollectionViewCell.h"
#import "ProfileViewController.h"
#import "TopHoodersViewController.h"

@interface TopHoodersViewController () <
    UICollectionViewDelegate, UICollectionViewDataSource,
    FSQCollectionViewDelegateAlignedLayout> {
  NSArray *arrHooders;
}
@property(weak, nonatomic) IBOutlet UICollectionView *colHooders;

@end

@implementation TopHoodersViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _colHooders.delegate = self;
  _colHooders.dataSource = self;
  [APPDelegate.tabBarController.customTabbar
      selectItemAtIndex:TabBarItemTypeNone];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [APPDelegate startLoadingView];
  [ServiceManager getTopHoodersForHood:ServiceManager.selctedHood.ID
                          onCompletion:^(BOOL success, NSArray *arrData) {
                            [APPDelegate stopLoadingView];
                            if (success) {
                              arrHooders = [arrData copy];
                              [_colHooders reloadData];
                            }
                          }];
}

- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {
  return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  if (arrHooders == nil || arrHooders.count == 0) {
    return 0;
  }

  switch (section) {
  case 0:
    return arrHooders.count > 0 ? 1 : 0;
    break;
  case 1:
    return arrHooders.count > 5
               ? 4
               : (arrHooders.count - 1 > 0 ? arrHooders.count - 1 : 0);
    break;
  case 2:
    return arrHooders.count > 5
               ? (arrHooders.count - 5 > 0 ? arrHooders.count - 5 : 0)
               : 0;
  default:
    return 0;
    break;
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  HooderCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                forIndexPath:indexPath];
  CGFloat radius = [self collectionView:collectionView
                                       layout:nil
                       sizeForItemAtIndexPath:indexPath
                           remainingLineSpace:0]
                       .height *
                   0.6 / 2.0;
  NSInteger index = 0;
  switch (indexPath.section) {
  case 0:
    index = 0;
    break;
  case 1:
    index = 1 + indexPath.row;
    break;
  case 2:
    index = 5 + indexPath.row;
    break;

  default:
    break;
  }
  LLUser *user = arrHooders[index];
  cell.imgVIew.layer.cornerRadius = radius;
  //cell.imgVIew.layer.borderColor = [UIColor orangeColor].CGColor;
  //cell.imgVIew.layer.borderWidth = 1;

  [cell.imgVIew sd_setImageWithURL:[NSURL URLWithString:user.photo]
                  placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
  cell.lblRank.text =
      [@"Rank " stringByAppendingFormat:@"%lu", (long)user.rank];

  cell.lblName.text = user.fullName;

  if (indexPath.section == 2) {
    cell.lblName.font = FONT_DEFAULT_REGULAR(10);
    cell.lblRank.font = FONT_DEFAULT_REGULAR(8);
  } else {
    cell.lblName.font = FONT_DEFAULT_REGULAR(13);
    cell.lblRank.font = FONT_DEFAULT_REGULAR(11);
  }

  return cell;
}

- (FSQCollectionViewAlignedLayoutSectionAttributes *)
             collectionView:(UICollectionView *)collectionView
                     layout:
                         (FSQCollectionViewAlignedLayout *)collectionViewLayout
attributesForSectionAtIndex:(NSInteger)sectionIndex {

  return [FSQCollectionViewAlignedLayoutSectionAttributes
      withHorizontalAlignment:FSQCollectionViewHorizontalAlignmentCenter
            verticalAlignment:FSQCollectionViewVerticalAlignmentCenter];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
      remainingLineSpace:(CGFloat)remainingLineSpace {
  switch (indexPath.section) {
  case 0:
  case 1:
    return CGSizeMake(130 * SCREEN_WIDTH / 320, 120 * SCREEN_HEIGHT / 568);
    break;
  default:
    return CGSizeMake(90 * SCREEN_WIDTH / 320, 96 * SCREEN_HEIGHT / 568);
    break;
  }
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger index = 0;
  switch (indexPath.section) {
  case 0:
    index = 0;
    break;
  case 1:
    index = 1 + indexPath.row;
    break;
  case 2:
    index = 5 + indexPath.row;
    break;

  default:
    break;
  }
  LLUser *user = arrHooders[index];
  [APPDelegate startLoadingView];
  [ServiceManager
      getProfileFor:user.userID
       onCompletion:^(BOOL success, LLUser *user) {
         [APPDelegate stopLoadingView];
         if (success) {
           [self performSegueWithIdentifier:@"toProfile" sender:user];
         }
       }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"toProfile"]) {
    ProfileViewController *pVC = segue.destinationViewController;
    pVC.user = sender;
    pVC.isFriendProfile = YES;
  }
}

@end
