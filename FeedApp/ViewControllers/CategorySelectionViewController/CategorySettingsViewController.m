//
//  CategorySelectionViewController.m
//  FeedApp
//
//  Created by TechLoverr on 17/09/16.
//
//

#import "CategorySettingsViewController.h"

@interface CategorySettingsViewController () <UITableViewDelegate,
UITableViewDataSource> {
    NSArray *arrData;
    NSMutableArray *arrSelection;
}
@property(weak, nonatomic) IBOutlet UITableView *tblCategories;

@end

@implementation CategorySettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrData = ServiceManager.sections;
    _tblCategories.allowsMultipleSelection = YES;
    _tblCategories.delegate = self;
    _tblCategories.dataSource = self;
    _tblCategories.tableFooterView = [UIView new];
    arrSelection = [[ServiceManager.loggedUser.interests
                     componentsSeparatedByString:@","] mutableCopy];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CatSelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    LLSection *section = arrData[indexPath.row];
    cell.lblName.text = section.name;
    cell.btnCheck.userInteractionEnabled = NO;
    cell.btnCheck.tag = indexPath.row;
    
    if ([arrSelection
         containsObject:[NSString
                         stringWithFormat:@"%lu", (long)section.ID]]) {
             cell.btnCheck.selected = YES;
         } else {
             cell.btnCheck.selected = NO;
         }
    return cell;
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
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!arrSelection) {
        arrSelection = [NSMutableArray new];
    }
    LLSection *section = arrData[indexPath.row];
    if ([arrSelection
         containsObject:[NSString
                         stringWithFormat:@"%lu", (long)section.ID]]) {
             [arrSelection
              removeObject:[NSString stringWithFormat:@"%lu", (long)section.ID]];
         } else {
             [arrSelection
              addObject:[NSString stringWithFormat:@"%lu", (long)section.ID]];
         }
    
    [_tblCategories reloadData];
}
- (IBAction)donePressed:(id)sender {
    if (arrSelection.count == 0) {
        [APPDelegate
         showAlertWithMessage:@"Atleast one category should be selected!"];
        return;
    }
    
    if (ServiceManager.loggedUser.interests !=
        [arrSelection componentsJoinedByString:@","]) {
        ServiceManager.loggedUser.interests =
        [arrSelection componentsJoinedByString:@","];
        [APPDelegate startLoadingView];
        [ServiceManager
         updateInterestsFor:ServiceManager.loggedUser
         onCompletion:^(BOOL success) {
             [APPDelegate stopLoadingView];
             NSMutableArray *arrSections = [NSMutableArray new];
             for (NSString *num in arrSelection) {
                 if (num.length && [num integerValue]) {
                     [arrSections addObject:[LLSection getSection:[num integerValue]]];
                 }
             }
             
             ServiceManager.selectedSections = [arrSections mutableCopy];
             
             [self.navigationController popViewControllerAnimated:YES];
             dispatch_after(
                            dispatch_time(DISPATCH_TIME_NOW,
                                          (int64_t)(1 * NSEC_PER_SEC)),
                            dispatch_get_main_queue(), ^{
                                [APPDelegate showAlertWithMessage:@"Categories updated"];
                            });
         }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation CatSelCell

@end
