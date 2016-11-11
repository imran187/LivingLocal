//
//  LLTabBarItem.h
//  FeedApp
//
//  Created by TechLoverr on 10/09/16.
//
//

#import <UIKit/UIKit.h>

@class LLTabBarItem;

@protocol LLTabBarItemDelegate <NSObject>

- (void)tabBarItemDidSelect:(LLTabBarItem *)item;

@end

@interface LLTabBarItem : UIView
@property(nonatomic, weak) IBOutlet UIImageView *imgView;
@property(nonatomic, weak) IBOutlet UILabel *lblName;
@property(nonatomic, weak) id<LLTabBarItemDelegate> itemDelegate;
@property(nonatomic, assign) BOOL selected;
@end
