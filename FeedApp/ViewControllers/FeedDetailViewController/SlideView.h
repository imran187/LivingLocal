//
//  SlideView.h
//  FeedApp
//
//  Created by TechLoverr on 17/09/16.
//
//

#import <UIKit/UIKit.h>

@interface SlideView
    : UIView <UICollectionViewDelegate, UICollectionViewDataSource,
              UICollectionViewDelegateFlowLayout> {
}
@property(weak, nonatomic) IBOutlet UICollectionView *colImages;
@property(strong, nonatomic) NSArray *arrImagesURL;
@property(strong, nonatomic) NSArray *arrImages;
@property(assign, nonatomic) CGRect oldFrame;

@end
