//
//  FilterCollectionView.m
//  FeedApp
//
//  Created by TechLoverr on 10/09/16.
//
//

#import "FilterCollectionView.h"

@implementation FilterCollectionView

- (void)awakeFromNib {
  [super awakeFromNib];

  _arrData = ServiceManager.sections;
  [self registerNib:[UINib nibWithNibName:@"FilterCollectionViewCell"
                                   bundle:nil]
      forCellWithReuseIdentifier:@"Cell"];
  self.allowsMultipleSelection = YES;
  self.delegate = self;
  self.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return _arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  FilterCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                forIndexPath:indexPath];
  LLSection *section = _arrData[indexPath.item];
  cell.lblName.text = section.name;
  cell.selected = [_arrSelectedData containsObject:section];

  if (cell.selected) {
    [collectionView selectItemAtIndexPath:indexPath
                                 animated:NO
                           scrollPosition:UICollectionViewScrollPositionNone];
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
            verticalAlignment:FSQCollectionViewVerticalAlignmentCenter
                  itemSpacing:10
                  lineSpacing:30
                       insets:UIEdgeInsetsZero];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
      remainingLineSpace:(CGFloat)remainingLineSpace {
  return CGSizeMake(85 * WIDTH_SCALE, 60 * HEIGHT_SCALE);
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  LLSection *section = _arrData[indexPath.item];
  [_arrSelectedData addObject:section];
  UICollectionViewCell *cell =
      [collectionView cellForItemAtIndexPath:indexPath];
  cell.selected = [_arrSelectedData containsObject:section];
}

- (void)collectionView:(UICollectionView *)collectionView
    didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
  LLSection *section = _arrData[indexPath.item];
  [_arrSelectedData removeObject:section];
  UICollectionViewCell *cell =
      [collectionView cellForItemAtIndexPath:indexPath];
  cell.selected = [_arrSelectedData containsObject:section];
}

@end
