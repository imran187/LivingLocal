//
//  ProfileOptionsCollectionView.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "ProfileOptionsCollectionView.h"

@implementation ProfileOptionsCollectionView

- (void)awakeFromNib {
  [super awakeFromNib];

  _arrOptions = @[
    @"My Activity",
    @"My Groups",
    @"My Events",
    @"Settings",
    @"Invite Friend"
  ];

  _arrImages =
      @[ @"activity", @"groups", @"events", @"setting", @"invite_friend" ];

  self.delegate = self;
  self.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return _arrOptions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ProfileOptionsCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                forIndexPath:indexPath];
  cell.lblName.text = _arrOptions[indexPath.item];
  cell.imgView.image = [UIImage imageNamed:_arrImages[indexPath.item]];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (_selectionHandler) {
    _selectionHandler(indexPath);
  }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                      layout:(UICollectionViewLayout *)
                                                 collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

  return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                 layout:(UICollectionViewLayout *)
                                            collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section {

  return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (_arrOptions.count > 3) {
    return CGSizeMake(IS_IPHONE_6 ? 72 : 80, collectionView.frame.size.height);
  }
  return CGSizeMake(SCREEN_WIDTH / 3, collectionView.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (SCREEN_WIDTH == 320 && _arrOptions.count > 3) {
    _imgArrow.hidden = scrollView.contentOffset.x > 30;
  }
}

@end
