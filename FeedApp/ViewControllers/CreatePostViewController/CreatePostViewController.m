//
//  CreatePostViewController.m
//  FeedApp
//
//  Created by TechLoverr on 08/09/16.
//
//

#import "CreatePostViewController.h"
#import "CustomeImagePicker.h"
#import "LLTabbarController.h"
#import "PHImageManager+CTAssetsPickerController.h"
#import <AZSClient/AZSClient.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface CreatePostViewController () <UITextViewDelegate,
                                        CustomeImagePickerDelegate> {
  NSMutableArray *arrImageCollection;
  NSMutableArray *arrUrls;
}

@property(weak, nonatomic)
    IBOutlet UICollectionView *collectionViewSelectedImages;
@property(nonatomic, strong) PHImageRequestOptions *requestOptions;
@property(weak, nonatomic) IBOutlet UILabel *lblPlaceholder;

@end

@implementation CreatePostViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _btnAddPhotos.imageView.contentMode = UIViewContentModeScaleAspectFit;
  _btnPost.imageView.contentMode = UIViewContentModeScaleAspectFit;
  _collectionViewSelectedImages.hidden = NO;
  _txtPost.layer.borderWidth = 1;
  _txtPost.layer.borderColor = UIColorFromRGB(0xc4c6ce).CGColor;
  _txtPost.delegate = self;
  _lblName.text = ServiceManager.loggedUser.fullName;
  _lblCategory.text = _group ? _group.groupName.uppercaseString : _section.name;
  [_ingUser
      sd_setImageWithURL:[NSURL URLWithString:ServiceManager.loggedUser.photo]
        placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];

    _ingUser.layer.borderColor = (ServiceManager.selctedHood.ID == ServiceManager.loggedUser.hoodId ? [UIColor clearColor] : THEME_ORANGE_COLOR).CGColor;
  _txtPost.textContainer.lineFragmentPadding = 15;

  self.requestOptions = [[PHImageRequestOptions alloc] init];
  self.requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
  self.requestOptions.deliveryMode =
      PHImageRequestOptionsDeliveryModeHighQualityFormat;

  UITapGestureRecognizer *tap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleTap:)];
  [self.view addGestureRecognizer:tap];

  if (_group) {
    _recommendationHeightConstraint.constant = 0;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  APPDelegate.tabBarController.customTabbar.hidden = YES;
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
}

- (void)viewWillDisappear:(BOOL)animated {
  APPDelegate.tabBarController.customTabbar.hidden = NO;
  //  [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (IBAction)closePressed:(id)sender {

  if (_group) {
    [self dismissViewControllerAnimated:YES
                             completion:^{

                             }];
  } else {

    [self.view endEditing:YES];
    LLTabBarController *tabBarController = (id)self.tabBarController;
    [tabBarController selectViewControllerAtIndex:HOME];

    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [self.navigationController popToRootViewControllerAnimated:YES];
        });
  }
}

- (IBAction)recommendationSwitchPressed:(UIButton *)sender {
  sender.selected = !sender.selected;
}

- (void)textViewDidChange:(UITextView *)textView {
  _lblPlaceholder.hidden = textView.text.length;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
  [_txtPost resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
  [_txtPost resignFirstResponder];
}

- (IBAction)actionAddPhotos:(id)sender {
  [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    dispatch_async(dispatch_get_main_queue(), ^{
      CustomeImagePicker *cip = [[CustomeImagePicker alloc] init];
      cip.delegate = self;
      [cip setHideSkipButton:NO];
      [cip setHideNextButton:NO];
      [cip setMaxPhotos:MAX_ALLOWED_PICK];
      [cip setShowOnlyPhotosWithGPS:NO];
      [cip setHighLightThese:arrUrls];
      [self presentViewController:cip
                         animated:YES
                       completion:^{
                         cip.lblHeader.text = _lblCategory.text;
                       }];
    });
  }];
}

- (void)imageSelected:(NSArray *)arrayOfImages {

  dispatch_async(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        dispatch_async(dispatch_get_main_queue(), ^{

                       }); // Main Queue to Display the Activity View
        int count = 0;
        arrImageCollection = [NSMutableArray new];
        arrUrls = [NSMutableArray arrayWithArray:arrayOfImages];
        for (NSString *imageURLString in arrayOfImages) {
          // Asset URLs
          ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
          [assetsLibrary assetForURL:[NSURL URLWithString:imageURLString]
              resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *representation =
                    [asset defaultRepresentation];
                CGImageRef imageRef = [representation fullScreenImage];
                UIImage *image = [UIImage imageWithCGImage:imageRef];
                if (imageRef) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                    [arrImageCollection addObject:image];

                    if (arrayOfImages.count == arrImageCollection.count) {
                      [_collectionViewSelectedImages reloadData];
                    }

                  });
                } // Valid Image URL
              }
              failureBlock:^(NSError *error){
              }];
          count++;
        } // All Images I got

      }); // Queue for reloading all images
}

#pragma mark -
#pragma mark - Collection View Methods

- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {

  return 1;
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {

  NSString *string =
      [textView.text stringByReplacingCharactersInRange:range withString:text];
  return string.length <= 1000;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {

  return arrImageCollection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  NSString *identifier = @"ImageCell";

  CustomImageCollectionCell *cell = (CustomImageCollectionCell *)[collectionView
      dequeueReusableCellWithReuseIdentifier:identifier
                                forIndexPath:indexPath];

  cell.imgViewCollectionThumb.contentMode = UIViewContentModeScaleAspectFill;
  cell.imgViewCollectionThumb.clipsToBounds = YES;
  cell.btnDeleteImage.hidden = NO;

  [cell.btnDeleteImage addTarget:self
                          action:@selector(deleteCollectionImage:)
                forControlEvents:UIControlEventTouchUpInside];
  cell.btnDeleteImage.tag = indexPath.row;

  cell.imgViewCollectionThumb.image = arrImageCollection[indexPath.row];
  return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                      layout:(UICollectionViewLayout *)
                                                 collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                 layout:(UICollectionViewLayout *)
                                            collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 0.0;
}

- (void)deleteCollectionImage:(UIButton *)sender {
  [arrUrls removeObjectAtIndex:sender.tag];
  [arrImageCollection removeObjectAtIndex:sender.tag];
  [_collectionViewSelectedImages reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)postPressed:(id)sender {
  [self.view endEditing:YES];
  NSString *post = [_txtPost.text
      stringByTrimmingCharactersInSet:[NSCharacterSet
                                          whitespaceAndNewlineCharacterSet]];

  if (post.length > 0) {
    [APPDelegate startLoadingView];

    if (arrImageCollection.count > 0) {
      [self
          uploadImagesAtIndex:0
                 onCompletion:^(BOOL success, NSArray *path) {
                   if (success) {
                     [ServiceManager
                              createPostFor:ServiceManager.loggedUser
                               articleTitle:post
                         articleDescription:@"null"
                                    section:_section
                                      group:_group
                                     photos:path
                                recommended:_btnRecommendation.selected
                                   fileList:@[]
                               onCompletion:^(BOOL success) {
                                 [APPDelegate stopLoadingView];
                                 if (success) {
                                   [self closePressed:nil];
                                   dispatch_after(
                                       dispatch_time(
                                           DISPATCH_TIME_NOW,
                                           (int64_t)(2.0 * NSEC_PER_SEC)),
                                       dispatch_get_main_queue(), ^{
                                         [self showAlertWithMessage:
                                                   @"Post created sucessfully"];

                                       });
                                 }
                               }];
                   }
                 }];
    } else {

      [ServiceManager
               createPostFor:ServiceManager.loggedUser
                articleTitle:post
          articleDescription:@"null"
                     section:_section
                       group:_group
                      photos:@[]
                 recommended:_btnRecommendation.selected
                    fileList:@[]
                onCompletion:^(BOOL success) {
                  [APPDelegate stopLoadingView];
                  if (success) {
                    [self showAlertWithMessage:@"Post created sucessfully"];

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                                 (int64_t)(2.0 * NSEC_PER_SEC)),
                                   dispatch_get_main_queue(), ^{
                                     [self closePressed:nil];
                                   });
                  }
                }];
    }
  } else {
    [self showAlertWithMessage:@"Enter Post!"];
  }
}

- (void)uploadImagesAtIndex:(NSInteger)index
               onCompletion:(void (^)(BOOL success, NSArray *path))completion {

  __block NSMutableArray *paths = [NSMutableArray new];
  __block NSInteger nextIndex = index + 1;

  [ServiceManager
      uploadBlobToContainer:arrImageCollection[index]
               onCompletion:^(BOOL success, NSString *path) {
                 if (success) {
                   [paths addObject:path];

                   if (arrImageCollection.count != nextIndex) {
                     [self uploadImagesAtIndex:nextIndex
                                  onCompletion:^(BOOL success, NSArray *path) {
                                    if (success) {
                                      [paths addObjectsFromArray:path];
                                      completion(YES, paths);
                                    } else {
                                      completion(NO, nil);
                                    }
                                  }];
                   } else {
                     completion(YES, paths);
                   }
                 } else {
                   completion(NO, nil);
                 }
               }];
}

@end

@implementation CustomImageCollectionCell
@synthesize imgViewCollectionThumb;

@end
