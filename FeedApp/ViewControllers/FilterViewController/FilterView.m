//
//  FilterViewController.m
//  FeedApp
//
//  Created by TechLoverr on 10/09/16.
//
//

#import "FilterView.h"

@implementation FilterView

- (IBAction)closePressed:(id)sender {

  [UIView animateWithDuration:0.5
      animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
      }
      completion:^(BOOL finished) {
        [self removeFromSuperview];
      }];
}
- (IBAction)donePressed:(id)sender {

  if (_colFilters.arrSelectedData.count == 0) {
    [APPDelegate
        showAlertWithMessage:@"Atleast one category should be selected!"];
    return;
  }

  _selectionHandler(_colFilters.arrSelectedData);

  [UIView animateWithDuration:0.5
      animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
      }
      completion:^(BOOL finished) {
        [self removeFromSuperview];
      }];
}

@end
