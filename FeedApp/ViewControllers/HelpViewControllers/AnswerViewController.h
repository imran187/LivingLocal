//
//  AnswerViewController.h
//  FeedApp
//
//  Created by TechLoverr on 12/09/16.
//
//

#import <UIKit/UIKit.h>
#import "LLHeaderLabel.h"

@interface AnswerViewController : UIViewController
@property(nonatomic, strong) NSString *titleString;
@property(nonatomic, strong) NSString *question;
@property (weak, nonatomic) IBOutlet LLHeaderLabel *lblTitle;
@property (weak, nonatomic) IBOutlet LLLabel *lblQuestion;
@property(nonatomic, strong) NSString *answer;
@property (weak, nonatomic) IBOutlet LLLabel *lblAnswer;
@end
