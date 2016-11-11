//
//  EventImageTableViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import "EventImageTableViewCell.h"
#import "SlideView.h"

@implementation EventImageTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}
- (IBAction)showSlideshow:(id)sender {
  SlideView *slideView =
      [[[NSBundle mainBundle] loadNibNamed:@"SlideView" owner:nil options:nil]
          firstObject];

  slideView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
  slideView.arrImagesURL = _event.imgArray;
  [APPDelegate.tabBarController.view addSubview:slideView];
  [UIView animateWithDuration:0.5
                   animations:^{
                     slideView.frame =
                         CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                   }];
}

- (void)setEvent:(LLEvent *)event {
  _event = event;

  if (event.imgArray.count == 1) {
    [_imgMain
        sd_setImageWithURL:[NSURL URLWithString:event.imgArray.firstObject]
          placeholderImage:[UIImage imageNamed:@"noPictureAvailable"]];
  } else if (event.imgArray.count > 1) {
    _imgMain.hidden = YES;
    [_imgOne sd_setImageWithURL:[NSURL URLWithString:event.imgArray.firstObject]
               placeholderImage:[UIImage imageNamed:@"noPictureAvailable"]];
    [_imgTwo sd_setImageWithURL:[NSURL URLWithString:event.imgArray[1]]
               placeholderImage:[UIImage imageNamed:@"noPictureAvailable"]];
    _btnCount.hidden = YES;
    if (event.imgArray.count > 2) {
        _btnCount.hidden = NO;
      [_btnCount
          setTitle:[@"+" stringByAppendingFormat:@"%lu",
                                                 _event.imgArray.count - 2]
          forState:UIControlStateNormal];
    }
  }
}

@end
