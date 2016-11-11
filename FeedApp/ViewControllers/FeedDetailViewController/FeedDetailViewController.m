//
//  FeedDetailViewController.m
//  FeedApp
//
//  Created by TechLoverr on 07/09/16.
//
//

#import "FeedDetailTableView.h"
#import "FeedDetailViewController.h"

@interface FeedDetailViewController () <UITextViewDelegate> {
  UITapGestureRecognizer *tapGesture;
  __weak IBOutlet UILabel *lblPlaceholder;
  __weak IBOutlet FeedDetailTableView *tblFeeds;
  __weak IBOutlet UIButton *btnSend;
}
@end

@implementation FeedDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view bringSubviewToFront:_txtComment];
  _txtComment.delegate = self;
  btnSend.imageView.contentMode = UIViewContentModeScaleAspectFit;
  [lblPlaceholder.superview bringSubviewToFront:lblPlaceholder];
  _txtComment.textContainerInset = UIEdgeInsetsMake(12, 16, 12, 16);

  tapGesture =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tapped)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        APPDelegate.tabBarController.customTabbar.hidden = YES;
    }
    
    NSNotificationCenter *notificationCenter =
    [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(keyBoardFrameWillUpdate:)
                               name:UIKeyboardWillChangeFrameNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(keyBoardFrameWillUpdate:)
                               name:UIKeyboardWillHideNotification
                             object:nil];
    if (_shouldStartEditing) {
        [_txtComment becomeFirstResponder];
    }
    
    tblFeeds.post = _post;
    [ServiceManager getPostDetail:_post
                     onCompletion:^(BOOL success, LLPost *post) {
                         if (success) {
                             tblFeeds.post = post;
                             self.lblHood.text =
                             [LLHood getHood:post.articleHood].name;
                             [tblFeeds reloadData];
                         }
                     }];
    
    self.lblHood.text = [LLHood getHood:_post.articleHood].name;
    
    if (_group) {
        _headerView.hidden = YES;
        _headerView2.hidden = NO;
        _lblGroupName.text = _group.groupName.uppercaseString;
    }else{
        _headerView.hidden = NO;
        _headerView2.hidden = YES;
    }
}

- (void)tapped {
  [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  NSString *text = [textField.text stringByReplacingCharactersInRange:range
                                                           withString:string];
  return text.length <= 800;
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyBoardFrameWillUpdate:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  NSTimeInterval animationDuration;
  UIViewAnimationCurve animationCurve;

  [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
  [userInfo[UIKeyboardAnimationDurationUserInfoKey]
      getValue:&animationDuration];

  UIViewAnimationOptions animationOptions =
      (animationCurve
       << 16); // convert from UIViewAnimationCurve to UIViewAnimationOptions

  CGRect keyboardRect = [[[notification userInfo]
      objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

  _bottomConstraint.constant =
      [UIScreen mainScreen].bounds.size.height - keyboardRect.origin.y;

  [UIView animateWithDuration:animationDuration
                        delay:0
                      options:animationOptions
                   animations:^{

                     [self.view layoutIfNeeded];
                   }
                   completion:nil];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
  [self.view addGestureRecognizer:tapGesture];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  [self.view removeGestureRecognizer:tapGesture];
}

- (IBAction)sendCommentPressed:(UIButton *)sender {

  [self.view endEditing:YES];
  NSString *comment = [_txtComment.text
      stringByTrimmingCharactersInSet:[NSCharacterSet
                                          whitespaceAndNewlineCharacterSet]];

  if (comment.length > 0) {
    sender.userInteractionEnabled = NO;
    [APPDelegate startLoadingView];
    [ServiceManager
        InsertCommentFor:ServiceManager.loggedUser
             commentText:comment
                 ForPost:_post
            onCompletion:^(BOOL success) {
              sender.userInteractionEnabled = YES;
              [APPDelegate stopLoadingView];
              if (success) {
                _txtComment.text = @"";
                [self textViewDidChange:_txtComment];
                [self showAlertWithMessage:@"Your comment was successful."];
                [ServiceManager getPostDetail:_post
                                 onCompletion:^(BOOL success, LLPost *post) {
                                   if (success) {
                                     tblFeeds.post = post;
                                     [tblFeeds reloadData];
                                   }
                                 }];
              }
            }];
  } else {
    [self showAlertWithMessage:@"Please enter comment"];
  }
}

- (void)textViewDidChange:(UITextView *)textView {
  lblPlaceholder.hidden = textView.text.length;
  _heightConstraint.constant =
      textView.contentSize.height > 43 ? textView.contentSize.height : 43;

  if (_heightConstraint.constant > 80) {
    _heightConstraint.constant = 80;
  }
}

@end
