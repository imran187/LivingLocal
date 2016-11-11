//
//  NotificationSettingsViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "NotificationSettingsViewController.h"

@interface NotificationSettingsViewController ()
@property(weak, nonatomic) IBOutlet UIButton *btnEmail;
@property(weak, nonatomic) IBOutlet UIButton *btnWeekly;
@property(weak, nonatomic) IBOutlet UIButton *btnPush;

@end

@implementation NotificationSettingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _btnEmail.selected =
      [ServiceManager.loggedUser.emailNotification isEqual:@"on"];
  _btnWeekly.selected =
      [ServiceManager.loggedUser.bellNotification isEqual:@"on"];
  _btnPush.selected = YES;
  // Do any additional setup after loading the view.
}
- (IBAction)donePressed:(id)sender {

  ServiceManager.loggedUser.bellNotification =
      _btnWeekly.selected ? @"on" : @"off";
  ServiceManager.loggedUser.emailNotification =
      _btnEmail.selected ? @"on" : @"off";

  [ServiceManager
      updateUserFor:ServiceManager.loggedUser
       onCompletion:^(BOOL success) {
         if (success) {
           [self.navigationController popViewControllerAnimated:YES];
           dispatch_after(
               dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
               dispatch_get_main_queue(), ^{
                 [APPDelegate showAlertWithMessage:@"Notification updated"];
               });
         } else {
           [APPDelegate
               showAlertWithMessage:@"Could not update notification settings"];
         }
       }];
}

- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)switchEmailNotificationsPressed:(UIButton *)sender {
  sender.selected = !sender.selected;
}
- (IBAction)switchPushNotificationPressed:(UIButton *)sender {
  sender.selected = !sender.selected;
}

@end
