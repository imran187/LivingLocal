//
//  EventInfoTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import <UIKit/UIKit.h>

@interface EventInfoTableViewCell : UITableViewCell
@property(nonatomic, weak) IBOutlet LLLabel *lblLocation;
@property(nonatomic, weak) IBOutlet LLLabel *lblDate;
@property(nonatomic, weak) IBOutlet LLLabel *lblEmail;
@property(nonatomic, weak) IBOutlet LLLabel *lblContactNo;
@property(nonatomic, weak) IBOutlet LLLabel *lblLink;
@property(nonatomic, weak) IBOutlet LLLabel *lblFees;
@property(nonatomic, weak) IBOutlet UILabel *lblPlaceholderFees;
@property(weak, nonatomic)
    IBOutlet NSLayoutConstraint *locationHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *dateHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeightConstraint;
@property(weak, nonatomic)
    IBOutlet NSLayoutConstraint *contactNoHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *linkHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *feesHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *locationTopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *dateTopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *emailTopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contactNoTopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *linkTopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *feesTopConstraint;
@property(strong, nonatomic) LLEvent *event;
@end
