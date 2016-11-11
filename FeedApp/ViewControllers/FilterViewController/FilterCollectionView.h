//
//  FilterCollectionView.h
//  FeedApp
//
//  Created by TechLoverr on 10/09/16.
//
//

#import "FSQCollectionViewAlignedLayout.h"
#import "FilterCollectionViewCell.h"
#import <UIKit/UIKit.h>

@interface FilterCollectionView
    : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource,
                        FSQCollectionViewDelegateAlignedLayout>

@property(nonatomic, strong) NSArray *arrData;
@property(nonatomic, strong) NSMutableArray *arrSelectedData;
@end
