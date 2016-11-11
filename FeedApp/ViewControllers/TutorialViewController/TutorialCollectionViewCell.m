//
//  TutorialCollectionViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "TutorialCollectionViewCell.h"

@implementation TutorialCollectionViewCell

- (void)prepareForReuse {
  [self.imgView.layer removeAllAnimations];
  self.imgView.transform = CGAffineTransformIdentity;
}

@end
