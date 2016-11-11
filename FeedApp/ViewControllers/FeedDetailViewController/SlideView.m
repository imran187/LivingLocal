//
//  SlideView.m
//  FeedApp
//
//  Created by TechLoverr on 17/09/16.
//
//

#import "SlideView.h"
#import "SlideViewCollectionViewCell.h"

@implementation SlideView

- (void)awakeFromNib {
  [super awakeFromNib];
  _oldFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
  [_colImages registerNib:[UINib nibWithNibName:@"SlideViewCollectionViewCell"
                                         bundle:nil]
      forCellWithReuseIdentifier:@"Cell"];
  _colImages.pagingEnabled = YES;
  _colImages.delegate = self;
  _colImages.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  if (_arrImages.count > 0) {
    return _arrImages.count;
  }

  return _arrImagesURL.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SlideViewCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                forIndexPath:indexPath];

  if (_arrImages.count > 0) {
    cell.imgView.image = _arrImages[indexPath.row];
  } else {
    [cell.imgView
        sd_setImageWithURL:[NSURL URLWithString:_arrImagesURL[indexPath.row]]
          placeholderImage:[UIImage imageNamed:@"noPictureAvailable"]];
  }
  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 50);
}

- (IBAction)closePressed:(id)sender {
  [UIView animateWithDuration:0.0
      animations:^{
        self.frame = _oldFrame;
      }
      completion:^(BOOL finished) {
        [self removeFromSuperview];
      }];
}

@end
