//
//  ProfileOptionsCollectionView.h
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "FSQCollectionViewAlignedLayout.h"
#import "ProfileOptionsCollectionViewCell.h"
#import <UIKit/UIKit.h>

@interface ProfileOptionsCollectionView
    : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate,
                        UICollectionViewDelegateFlowLayout,
                        FSQCollectionViewDelegateAlignedLayout>

@property(nonatomic, strong) NSArray *arrOptions;
@property(nonatomic, strong) NSArray *arrImages;
@property(strong, nonatomic) UIImageView *imgArrow;
@property(nonatomic, strong) void (^selectionHandler)(NSIndexPath *);
@end
