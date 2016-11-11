//
//  FeedsTableView.h
//  FeedApp
//
//  Created by TechLoverr on 03/09/16.
//
//

#import <UIKit/UIKit.h>

@interface FeedsTableView
    : UITableView <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray *arrFeeds;
@property(nonatomic, copy) void (^moreRowsHandler)(void);
@property(nonatomic, copy) void (^moreReplyHandler)(LLPost *);
@property(nonatomic, copy) void (^selectionHandler)(LLPost *);
@property(nonatomic, copy) void (^replyHandler)(LLPost *);
@end
