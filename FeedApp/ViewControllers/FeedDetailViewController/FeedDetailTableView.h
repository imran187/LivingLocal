//
//  FeedDetailTableView.h
//  FeedApp
//
//  Created by TechLoverr on 07/09/16.
//
//

#import <UIKit/UIKit.h>

@interface FeedDetailTableView
    : UITableView <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) LLPost *post;
@end
