//
//  MenuViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "MenuOptionsTableViewCell.h"
#import "MenuTableViewCell.h"
#import "MenuViewController.h"
#import "SlideView.h"

#define kHoodsSegue @"toHoods"
#define kHelpSegue @"toHelpSegue"
#define kWebSegue @"toWebContent"
#define kUserSetting @"toUserSetting"

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource> {
  NSArray *arrName;
  NSArray *arrImages;
  NSArray *arrOptions;
  BOOL isMenuExpanded;
}
@property(weak, nonatomic) IBOutlet UITableView *tblMenu;
@property(weak, nonatomic) IBOutlet UIView *viewHeader;

@end

@implementation MenuViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  //  self.viewHeader.layer.masksToBounds = NO;
  //  self.viewHeader.layer.shadowOffset = CGSizeMake(0, 2);
  //  self.viewHeader.layer.shadowRadius = 1;
  //  self.viewHeader.layer.shadowOpacity = 0.3;

  _imgUser.layer.borderColor = [UIColor clearColor].CGColor;
  arrName =
      @[@"My Hood", @"Hoods", @"Top Hooders", @"About Living Local", @"My Settings" ];

  arrImages = @[ @"home_menu", @"hoods", @"top-hooders", @"about_living-local", @"settings" ];

  arrOptions = @[
    @"How It Works",
    @"Terms",
    @"Privacy Policy",
    @"FAQ",
    @"Contact Living Local"
  ];
  _tblMenu.tableFooterView = [UIView new];
  _tblMenu.delegate = self;
  _tblMenu.dataSource = self;
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _lblName.text = ServiceManager.loggedUser.fullName;
    _lblName.userID = ServiceManager.loggedUser.userID;
    _imgUser.userID = ServiceManager.loggedUser.userID;
  _lblHoodName.text = ServiceManager.loggedUser.hoodName;
  _lblRank.text = [@"Rank "
      stringByAppendingFormat:@"%ld", (long)ServiceManager.loggedUser.rank];
  [_imgUser
      sd_setImageWithURL:[NSURL URLWithString:ServiceManager.loggedUser.photo]
        placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  if (section == 3) {
    return 1 + (isMenuExpanded ? arrOptions.count + 1 : 0);
  }

  return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return arrImages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  if (indexPath.row > 0) {

    if (indexPath.row == 2) {
      UITableViewCell *cell =
          [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:@"blankCell"];
      return cell;
    }

    MenuOptionsTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"OptionCell"];
    cell.lblName.text = arrOptions[indexPath.row - 2];
    cell.viewSeperator.hidden = NO;
    if (indexPath.row == 6) {
      cell.viewSeperator.hidden = YES;
    }
    return cell;
  }

  MenuTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  cell.lblName.text = arrName[indexPath.section];
  cell.imgView.image = [UIImage imageNamed:arrImages[indexPath.section]];
  cell.viewSeperator.hidden = NO;
  if (indexPath.section == 3) {
    cell.imgArrow.hidden = NO;
    if (isMenuExpanded) {
      cell.imgArrow.highlighted = YES;
    } else {
      cell.imgArrow.highlighted = NO;
    }

  } else {
    cell.imgArrow.hidden = YES;
  }

  if (indexPath.section == arrImages.count - 1 ||
      (indexPath.section == 3 && isMenuExpanded)) {
    cell.viewSeperator.hidden = YES;
  } else {
    cell.viewSeperator.hidden = NO;
  }

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 3) {
    if (isMenuExpanded) {
      if (indexPath.row == 0) {
        return 65;
      }
      if (indexPath.row == 1) {
        return 10;
      } else {
        return 34;
      }
    }
  }

  return 65;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 3) {
    switch (indexPath.row) {
    case 0:
      isMenuExpanded = !isMenuExpanded;
      [tableView reloadSections:[NSIndexSet indexSetWithIndex:2]
               withRowAnimation:UITableViewRowAnimationNone];
      break;
    case 2: {
      SlideView *slideView =
          [[[NSBundle mainBundle] loadNibNamed:@"SlideView"
                                         owner:nil
                                       options:nil] firstObject];

      slideView.frame =
          CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
      slideView.arrImages = @[
        [UIImage imageNamed:@"t1"],
        [UIImage imageNamed:@"t2"],
        [UIImage imageNamed:@"t3"],
        [UIImage imageNamed:@"t4"],
        [UIImage imageNamed:@"t5"]
      ];

      [slideView.colImages reloadData];
      [APPDelegate.window addSubview:slideView];
      [UIView animateWithDuration:0.5
                       animations:^{
                         slideView.frame =
                             CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                       }];
    } break;
    case 3: {
      [APPDelegate.tabBarController performSegueWithIdentifier:kWebSegue
                                                        sender:@"Terms"];
      [APPDelegate.sideMenu hideMenuViewController];
      isMenuExpanded = false;

      break;
    }
    case 4: {
      [APPDelegate.tabBarController performSegueWithIdentifier:kWebSegue
                                                        sender:@"Privacy"];
      [APPDelegate.sideMenu hideMenuViewController];
      isMenuExpanded = false;

      break;
    }
    case 5: {
      [APPDelegate.tabBarController performSegueWithIdentifier:kHelpSegue
                                                        sender:nil];
      [APPDelegate.sideMenu hideMenuViewController];
      isMenuExpanded = false;

      break;
    }
    case 6: {
      [APPDelegate.tabBarController performSegueWithIdentifier:kHelpSegue
                                                        sender:@"ContactUs"];
      [APPDelegate.sideMenu hideMenuViewController];
      isMenuExpanded = false;

      break;
    }
    default:
      break;
    }
  } else if (indexPath.section == 1) {
    [APPDelegate.tabBarController performSegueWithIdentifier:kHoodsSegue
                                                      sender:nil];
    [APPDelegate.sideMenu hideMenuViewController];
  } else if (indexPath.section == 2) {
    UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *topHoodersVC = [storyboard
        instantiateViewControllerWithIdentifier:@"TopHoodersViewController"];
    [APPDelegate.tabBarController.selectedViewController
        showViewController:topHoodersVC
                    sender:nil];
    [APPDelegate.sideMenu hideMenuViewController];
  }else if (indexPath.section == 0) {
      ServiceManager.selctedHood = [LLHood getHood: ServiceManager.loggedUser.hoodId];
      [APPDelegate.sideMenu hideMenuViewControllerWithCompletionHandler:^{
          [APPDelegate.tabBarController
           selectViewControllerAtIndex:0];
          [APPDelegate.tabBarController.customTabbar
           selectItemAtIndex:TabBarItemTypeHome];
          [[[APPDelegate.tabBarController
             selectedViewController] topViewController] viewWillAppear:YES];
      }];
  } else if (indexPath.section == 4) {
    [APPDelegate.tabBarController performSegueWithIdentifier:kUserSetting
                                                      sender:nil];
    [APPDelegate.sideMenu hideMenuViewController];
  }

  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView reloadData];
      });
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
- (IBAction)hoodNameTapped:(id)sender {

  ServiceManager.selctedHood =
      [LLHood getHood:ServiceManager.loggedUser.hoodId];
  [APPDelegate.tabBarController selectViewControllerAtIndex:0];
  [APPDelegate.tabBarController.customTabbar
      selectItemAtIndex:TabBarItemTypeHome];
  [APPDelegate.sideMenu hideMenuViewControllerWithCompletionHandler:^{
    [[APPDelegate.tabBarController.selectedViewController topViewController]
        viewWillAppear:YES];
  }];
}

@end
