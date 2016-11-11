//
//  BadgeCollectionView.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "BadgeCollectionView.h"
#import "BadgeCollectionViewCell.h"

@implementation BadgeCollectionView

- (void)awakeFromNib {
  [super awakeFromNib];

  self.delegate = self;
  self.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  BadgeCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                forIndexPath:indexPath];

  return cell;
}

@end
