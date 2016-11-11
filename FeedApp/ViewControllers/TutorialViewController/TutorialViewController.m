//
//  TutorialViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "TutorialCollectionViewCell.h"
#import "TutorialViewController.h"

@interface TutorialViewController () <UICollectionViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegateFlowLayout>
@property(weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property(weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property(weak, nonatomic) IBOutlet UIButton *btnLogIn;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _colTutorial.delegate = self;
  _colTutorial.dataSource = self;
  _pageControl.userInteractionEnabled = NO;
  _pageControl.numberOfPages = 3;
  _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];

  NSString *email =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
  NSString *password =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];

  if (email && email.length) {
    [APPDelegate startLoadingView];

    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [ServiceManager
                 loginUser:email
              withPassword:password
              onCompletion:^(BOOL success) {

                if (!success) {
                  [APPDelegate stopLoadingView];
                  //[APPDelegate showAlertWithMessage:@"Invalid email id or
                  // password!"];
                } else {

                  [ServiceManager getHoodsOnCompletion:^(BOOL success) {
                    if (success) {
                      ServiceManager.selctedHood =
                          [LLHood getHood:ServiceManager.loggedUser.hoodId];
                      [ServiceManager getSectionsOnCompletion:^(BOOL success) {
                        if (success) {
                          [APPDelegate stopLoadingView];
                          if (success) {
                            [self performSegueWithIdentifier:@"toHome"
                                                      sender:nil];
                          }
                        } else {
                          [APPDelegate stopLoadingView];
                        }
                      }];
                    } else {
                      [APPDelegate stopLoadingView];
                    }

                  }];
                }
              }];

        });
  }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return _pageControl.numberOfPages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TutorialCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell0"
                                                forIndexPath:indexPath];
  cell.imgView.image = [UIImage
      imageNamed:[@"tutorial_"
                     stringByAppendingFormat:@"%ld", indexPath.item + 1]];
  cell.imgtext.image = [UIImage
      imageNamed:[@"tutorial_text_"
                     stringByAppendingFormat:@"%ld", indexPath.item + 1]];
  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [[UIScreen mainScreen] bounds].size;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
  UIImageView *imgView = ((TutorialCollectionViewCell *)cell).imgView;

  [UIView animateWithDuration:12
                   animations:^{
                     imgView.transform = CGAffineTransformMakeScale(1.25, 1.25);
                   }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSIndexPath *indexPath = [_colTutorial
      indexPathForItemAtPoint:CGPointMake(_colTutorial.contentOffset.x + 100,
                                          _colTutorial.contentOffset.y)];

  _pageControl.currentPage = indexPath.item;

  _btnLogIn.hidden = _pageControl.currentPage != _pageControl.numberOfPages - 1;
  _btnSignUp.hidden =
      _pageControl.currentPage != _pageControl.numberOfPages - 1;
}

@end
