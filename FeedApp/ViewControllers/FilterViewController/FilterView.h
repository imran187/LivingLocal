//
//  FilterViewController.h
//  FeedApp
//
//  Created by TechLoverr on 10/09/16.
//
//

#import "FilterCollectionView.h"
#import "LLLabel.h"
#import <UIKit/UIKit.h>
@interface FilterView : UIView
@property(weak, nonatomic) IBOutlet LLLabel *lblTitle;
@property(weak, nonatomic) IBOutlet FilterCollectionView *colFilters;
@property(nonatomic, copy) void (^selectionHandler)(NSMutableArray *);
@end
