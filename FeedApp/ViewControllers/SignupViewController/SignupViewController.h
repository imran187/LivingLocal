//
//  SignupViewController.h
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController
@property(weak, nonatomic) IBOutlet LLTextField *txtFirstName;
@property(weak, nonatomic) IBOutlet LLTextField *txtLastName;
@property(weak, nonatomic) IBOutlet LLTextField *txtEmail;
@property(weak, nonatomic) IBOutlet LLTextField *txtPassword;
@property(weak, nonatomic) IBOutlet LLTextField *txtConfirmPassword;
@property(weak, nonatomic) IBOutlet LLTextField *txtCode;
@end
