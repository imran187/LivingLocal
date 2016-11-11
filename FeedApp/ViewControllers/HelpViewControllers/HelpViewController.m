//
//  HelpViewController.m
//  FeedApp
//
//  Created by TechLoverr on 12/09/16.
//
//

#import "AnswerViewController.h"
#import "HelpViewController.h"
#import <MessageUI/MessageUI.h>

@interface HelpViewController () <UITableViewDataSource, UITableViewDelegate,
                                  MFMailComposeViewControllerDelegate> {
}
@property(weak, nonatomic) IBOutlet UITableView *tblHelp;
@property(weak, nonatomic) IBOutlet UILabel *lblTitle;
@end

@implementation HelpViewController

- (void)viewDidLoad {
  if (_titleString != nil) {
    _lblTitle.text = _titleString;
  }
  [super viewDidLoad];
  if (_arrData == nil) {
    _arrData = @[
      @"Getting Started",
      @"Managing Your Account",
      @"Timeline POSTS",
      @"Others"
    ];
  }

  _tblHelp.delegate = self;
  _tblHelp.dataSource = self;
  _tblHelp.tableFooterView = [UIView new];

  if (_shouldHideLogo) {
    _logoHeightConstraint.constant = 0;
  }

  if (_cellBGColor == nil) {
    _cellBGColor = UIColorFromRGB(0xff9002);
  }

  if (_cellSelectionColor == nil) {
    _cellSelectionColor =
        [UIColor colorWithRed:0.137 green:0.463 blue:0.725 alpha:1.00];
  }

  if (_textColor == nil) {
    _textColor = [UIColor whiteColor];
  }

  if (_separatorColor == nil) {
    _separatorColor = [UIColor whiteColor];
  }

  _tblHelp.separatorColor = _separatorColor;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  cell.textLabel.textColor = _textColor;
  cell.textLabel.text = _arrData[indexPath.row];
  cell.accessoryView = [[UIImageView alloc]
      initWithImage:[UIImage imageNamed:@"user_setting-back"]];
  UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
  UIView *defBGView = [[UIView alloc] initWithFrame:cell.bounds];
  cell.backgroundColor = [UIColor clearColor];

  CGRect rect = cell.bounds;
  rect.origin.y = rect.size.height - 1;
  rect.size.height = 1;
  rect.size.width = SCREEN_WIDTH;
  UIView *view = [[UIView alloc] initWithFrame:rect];
  view.backgroundColor = _separatorColor;
  [defBGView addSubview:view];
  cell.contentView.backgroundColor = [UIColor clearColor];
  cell.backgroundColor = [UIColor clearColor];
  defBGView.backgroundColor = _cellBGColor;
  bgView.backgroundColor = _cellSelectionColor;
  cell.selectedBackgroundView = bgView;
  cell.clipsToBounds = NO;
  cell.backgroundView = defBGView;
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
      });
  if (_shouldNotNavigate) {
    if (indexPath.row == 0) {
      if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail =
            [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Report a technical issue"];
        [mail setMessageBody:@"Here is some main text in the email!" isHTML:NO];
        [mail setToRecipients:@[ @"support@livinglocal.com" ]];

        [self presentViewController:mail animated:YES completion:NULL];
      } else {
        NSLog(@"This device cannot send email");
      }
    }
    return;
  }

  UIStoryboard *storyboard =
      [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  if (_titleString != nil) {
    NSArray *arrData;

    NSInteger index = 3;

    if ([_titleString isEqual:@"Getting Started"]) {
      index = 0;
    } else if ([_titleString isEqual:@"Managing Your Account"]) {
      index = 1;
    } else if ([_titleString isEqual:@"Timeline POSTS"]) {
      index = 2;
    }

    switch (index) {
    case 0:
      arrData = @[
        @"A Hood is where you live, reside and belong. That place you call "
        @"home is your Hood. The place where all your daily needs are taken "
        @"care of. The place where you take your Dog for a walk, your gym, "
        @"your grocery, your evening hangout with friends… everything that "
        @"you do in your area of residence. That’s your Hood.",
        @"Hooders is a proud resident of their Hood. We all have an identity "
        @"wrt our School, College or workplace. Why not an identity based on "
        @"our Hood. Be proud and shout “I am a Hooder” cause you are the "
        @"smart one to Claim Your Hood. Everyone from the same area and same "
        @"Hood are fellow Hooders. They are the ones you can reach out to for "
        @"Help or Recommendations on the Living Local social platform.",
        @"Step 1: Create an account\n•	Go to www.livinglocal.com\n•	Select "
        @"your Hood (where you live) from the dropdown list. (please note: if "
        @"your Hood is not listed then it will be added soon as we expand to "
        @"other Hoods)\n•	Enter your details and click on the button - "
        @"CLAIM YOUR HOOD\n•	Alternatively login via Facebook or "
        @"Twitter\n\nStep 2: Confirm your Email address\nWhen you sign up or "
        @"change your email address Living Local will send you a verification "
        @"email with a verification link. This way you can confirm that your "
        @"email address is connected to your account. Here are the "
        @"steps.\n•	"
        @"You will get a verification email from Living Local on your email "
        @"that you used for registering.\n•	Please go to your email and "
        @"select the link\n•	That will take you to the Login Page\n•	Enter "
        @"your username and password and Enter your HOOD",
        @"1.	Go to www.livinglocal.com\n2.	On the top right of your "
        @"screen "
        @"enter your login details that were used to signup. Username (email "
        @"address) and Password. Click on Login",
        @"Don’t sweat. We will get you right back in. Just follow these "
        @"steps.\n•	Just below the Login in a Forgot Password link. Click "
        @"on that link.\n•	Enter your email address and then press Reset "
        @"Password.\n•	Please check your email at this point where a "
        @"reset link has been sent.\n•	Click on the link sent to your "
        @"email.\n•	Reset your password."
      ];
      break;

    case 1:
      arrData = @[
        @"Once you have logged in and you want to change or update your "
        @"account settings, change number of times you want to receive "
        @"notifications, change your email, password, update your date of "
        @"birth etc.\n•	Click on your DP (profile picture) on the right "
        @"hand top header.\n•	From the dropdown select Settings\n•	You "
        @"can "
        @"change your details and update your choices on this page.",
        @"Once you have logged in and you want to change or update your "
        @"account settings, change number of times you want to receive "
        @"notifications, change your email, password, update your date of "
        @"birth\n•	Click on your DP (profile picture) on the right hand "
        @"top header.\n•	From the dropdown select Settings\n•	You "
        @"can "
        @"change your email notification preferences on this page.",
        @"•	In the Account setting page, enter your new password in the "
        @"password field.\n•	Once you click save, a verification email will "
        @"be sent to your registered email.\n•	In your email, click on "
        @"the verification link to accept your changes and login back with "
        @"your new details.",
        @"•	Click on your default DP (profile picture) on the right hand "
        @"top header.\n•	Select My Profile to go to your profile "
        @"page.\n•	In your Profile page, hover your mouse over the "
        @"default "
        @"DP and click on it.\n•	Your device will open the option to "
        @"browse and select the image that you want to upload.\n•	Simply "
        @"select your choice of Profile Image that you want for your account "
        @"and select it.",
        @"In your Profile page, next to About Me and My Hood is an Edit icon "
        @"that you can click to edit the text inside. Simply click on that "
        @"edit icon (which turns in to a check mark), edit the text inside "
        @"the box. When you are done editing the text then simply click on "
        @"the check mark. Your new edited profile will be saved.",
        @"You can choose to select the categories you like so that people "
        @"looking at your profile know your interests. By default all the "
        @"categories are selected in your profile. To remove a category "
        @"simply click on the cross (x) next to the category. To add a "
        @"category select the dropdown next to Categories of Interest. Under "
        @"that select a category that you have not selected or deselected in "
        @"the past."
      ];
      break;

    case 2:
      arrData = @[
        @"•	Under the \"Post\" heading is a box where you type in the "
        @"details of the post.\n•	Select the Category in which your post "
        @"best fits.\n•	If your Post is a Recommendation then you may "
        @"click on the checkbox next to the text \"Is this a "
        @"Recommendation\"\n•	If you need to share a photo - Click on Add "
        @"Photos icon next to the Post button. You can add multiple pictures "
        @"one by one using Add Photos.\n•	Click on Post to publish your "
        @"question in the timeline.",
        @"Feel like communicating a fellow Hooder on a specific Post.\nTo "
        @"Reply to a post simply follow these steps:\n•	In the main "
        @"Timeline, scroll down to the specific Post that you want to "
        @"Reply.\n•	Type your response in the Reply Box in that "
        @"post.\n•	"
        @"Click on Reply",
        @"Think of Relevant like the “Like” button. The difference is in the "
        @"name itself. If you as a Hooder who comes across a Post or a Reply "
        @"that seems like a Relevant post to you then you click on the "
        @"Relevant button. When you click on it you will see that the counter "
        @"increases on the Relevant button and it turns Orange.",
        @"•	To select Relevant (which is grey by default) you need to go "
        @"to "
        @"that post and its replies.\n•	If there is a Post or a Reply "
        @"from other Hooder, which you think is Relevant then you may click "
        @"on the Relevant tickmark.\n•	It will turn Orange and "
        @"increase the counter of that Relevant by 1.",
        @"All the “I Recommend” posts that your fellow Hooders have posted "
        @"with Recommendations and suggestions in different Categories get "
        @"collected in the Recommendations page. Your one stop page to get "
        @"all the Recommendations and make your local living easier.",
        @"1.	Click on the profile Picture on the timeline "
        @"header.\n2.	"
        @"Click on My Profile.\n3.	Click on My Activity to see the all "
        @"your posts and the photos uploaded by you."
      ];

      break;

    case 3:

      arrData = @[
        @"Want to see what’s happening in other hoods? Are you going to "
        @"the other hood and have a query that you need help with? It’s "
        @"pretty simple. Just follow these steps to go see another Hoods "
        @"timeline.\n•	On the timeline page, click on the Hoods icon "
        @"on the banner to see the map of your city. All the currently "
        @"open Hoods are listed there.\n•	Select the hood you want to "
        @"visit.\n•	This will take you to the timeline of the Hood "
        @"you wish to explore.\n•	You can always go back to Your Hood "
        @"timeline by clicking on your DP on top header and selecting “My "
        @"Hood Timeline”."
      ];
      break;

    default:
      break;
    }

    [self performSegueWithIdentifier:@"toAnswer"
                              sender:@[
                                _arrData[indexPath.row],
                                arrData[indexPath.row]
                              ]];
  } else {
    HelpViewController *helpVC = [storyboard
        instantiateViewControllerWithIdentifier:@"HelpViewController"];
    helpVC.titleString = _arrData[indexPath.row];

    switch (indexPath.row) {
    case 0:
      helpVC.arrData = @[
        @"What is Hood?",
        @"Who are Hooders?",
        @"How do I Claim my Hood?",
        @"How do I Login to my Hood?",
        @"oh No! I forgot my password."
      ];
      break;
    case 1:
      helpVC.arrData = @[
        @"Where do I setup my details like: Date of Birth, gender?",
        @"Where do I setup my email notification Preferences?",
        @"Where do I Reset/Change my password?",
        @"How do I upload my Profile Picture/ DP?",
        @"How do I edit my profile text About Me, My Hood?",
        @"How do I add/ remove my Categories of interest in my profile?"
      ];
      break;
    case 2:
      helpVC.arrData = @[
        @"How do I create a Post?",
        @"How do I Reply to a Post?",
        @"What is the “Relevant” text (Single tickmark) that I see next to "
        @"the posts?",
        @"How do I select the Relevant (Single tickmark) option in the  post?",
        @"What is the Recommendations page all about?",
        @"How do I see all my Post activities?"
      ];
      break;

    case 3:
      helpVC.arrData = @[ @"What if I want to explore other Hoods?" ];
      break;
    default:
      break;
    }

    [self.navigationController pushViewController:helpVC animated:YES];
  }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
  switch (result) {
  case MFMailComposeResultSent:
    NSLog(@"You sent the email.");
    break;
  case MFMailComposeResultSaved:
    NSLog(@"You saved a draft of this email");
    break;
  case MFMailComposeResultCancelled:
    NSLog(@"You cancelled sending this email.");
    break;
  case MFMailComposeResultFailed:
    NSLog(@"Mail failed:  An error occurred when trying to compose this email");
    break;
  default:
    NSLog(@"An error occurred when trying to compose this email");
    break;
  }

  [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  // Remove seperator inset
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }

  // Prevent the cell from inheriting the Table View's margin settings
  if ([cell
          respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    [cell setPreservesSuperviewLayoutMargins:NO];
  }

  // Explictly set your cell's layout margins
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"toAnswer"]) {
    AnswerViewController *vc = segue.destinationViewController;
    vc.titleString = _titleString;
    vc.question = [sender firstObject];
    vc.answer = [sender lastObject];
  }
}

@end
