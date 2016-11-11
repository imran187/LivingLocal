//
//  CreateEventViewController.m
//  FeedApp
//
//  Created by TechLoverr on 18/09/16.
//
//

#import "CreateEventViewController.h"
#import "CreatePostViewController.h"
#import "CustomeImagePicker.h"
#import "LLFormTextField.h"
#import "LLLabel.h"
#import "LLTextView.h"
#import "PHImageManager+CTAssetsPickerController.h"
#import <ActionSheetPicker.h>
#import <TPKeyboardAvoidingScrollView.h>

@interface CreateEventViewController () <
UITextViewDelegate, UITextFieldDelegate, CustomeImagePickerDelegate,
UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *arrImageCollection;
    NSMutableArray *arrUrls;
    LLSection *section;
    LLEvent *event;
}
@property(weak, nonatomic) IBOutlet LLFormTextField *txtEventName;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtLink;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property(weak, nonatomic) IBOutlet LLTextView *txtDescription;
@property(weak, nonatomic) IBOutlet LLLabel *lblDescPlaceholder;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtStartDate;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtEndDate;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtStartTime;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtEndTime;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtCategory;
@property(weak, nonatomic) IBOutlet UICollectionView *colImages;
@property(weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtVenue;
@property(nonatomic, strong) PHImageRequestOptions *requestOptions;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtEmailId;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtPhoneNo;
@property(weak, nonatomic)
IBOutlet NSLayoutConstraint *colPhotosHeightConstraint;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtFees;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtAgerestriction;
@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _colImages.delegate = self;
    _colImages.dataSource = self;
    [_lblDescPlaceholder.superview bringSubviewToFront:_lblDescPlaceholder];
    if (self.tabBarController) {
        APPDelegate.tabBarController.customTabbar.hidden = YES;
    }
    
    _txtDescription.delegate = self;
    _txtStartDate.delegate = self;
    _txtEndDate.delegate = self;
    _txtStartTime.delegate = self;
    _txtEndTime.delegate = self;
    _txtCategory.delegate = self;
    _txtEventName.delegate = self;
    _txtLink.delegate = self;
    _txtVenue.delegate = self;
    _txtFees.delegate = self;
    _txtAgerestriction.delegate = self;
    _txtPhoneNo.delegate = self;
    _txtEmailId.delegate = self;
    
    event = [LLEvent new];
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode =
    PHImageRequestOptionsDeliveryModeHighQualityFormat;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidChange:(UITextView *)textView {
    _lblDescPlaceholder.hidden = textView.text.length;
    [_lblDescPlaceholder.superview bringSubviewToFront:_lblDescPlaceholder];
}
- (IBAction)createEventPressed:(id)sender {
    [self.view endEditing:YES];
    if (_txtEventName.text.length == 0) {
        [self showAlertWithMessage:@"Please enter event name"];
        return;
    }
    
    if (_txtCategory.text.length == 0) {
        [self showAlertWithMessage:@"Select category!"];
        return;
    }
    
    if (_txtStartDate.text.length == 0) {
        [self showAlertWithMessage:@"Please select start date"];
        return;
    }
    
    if (_txtEndDate.text.length == 0) {
        [self showAlertWithMessage:@"Please select end date"];
        return;
    }
    
    if (_txtVenue.text.length == 0) {
        [self showAlertWithMessage:@"Please select event venue"];
        return;
    }
    
    if (_txtStartTime.text.length == 0) {
        [self showAlertWithMessage:@"Please select start time"];
        return;
    }
    
    if (_txtEndTime.text.length == 0) {
        [self showAlertWithMessage:@"Please select end time"];
        return;
    }
    
    if (_txtEmailId.text.length == 0) {
        [self showAlertWithMessage:@"Please enter email address"];
        return;
    }
    
    if (![ValidationsHelper isGivenEmailValid:_txtEmailId.text]) {
        [self showAlertWithMessage:@"Please enter valid email address"];
        return;
    }
    
    if (_txtDescription.text.length == 0) {
        [self showAlertWithMessage:@"Please enter event description"];
        return;
    }
    
    event.eventName = _txtEventName.text;
    event.eventLink = _txtLink.text;
    event.eventVenue = _txtVenue.text;
    event.eventDescription = _txtDescription.text;
    event.contactNo = _txtPhoneNo.text;
    event.emailId = _txtEmailId.text;
    event.fees = _txtFees.text;
    event.age = _txtAgerestriction.text;
    
    [APPDelegate startLoadingView];
    
    if (arrImageCollection.count > 0) {
        [self
         uploadImagesAtIndex:0
         onCompletion:^(BOOL success, NSArray *path) {
             if (success) {
                 event.eventCoverPhoto = path.firstObject;
                 [ServiceManager
                  createEvent:event
                  forUser:ServiceManager.loggedUser
                  onCompletion:^(BOOL success, NSString *eventId) {
                      
                      if (!success) {
                          [APPDelegate stopLoadingView];
                          return;
                      }
                      
                      if (arrImageCollection.count == 1) {
                          [APPDelegate stopLoadingView];
                          [self dismissViewControllerAnimated:YES
                                                   completion:^{
                                                       [APPDelegate
                                                        showAlertWithMessage:
                                                        @"Event posted "
                                                        @"successfully"];
                                                   }];
                      } else {
                          [ServiceManager
                           addImages:[path subarrayWithRange:
                                      NSMakeRange(
                                                  1, path.count - 1)]
                           forEvent:eventId
                           onCompletion:^(BOOL success) {
                               [APPDelegate stopLoadingView];
                               if (success) {
                                   
                                   [self
                                    dismissViewControllerAnimated:YES
                                    completion:^{
                                        [APPDelegate
                                         showAlertWithMessage:
                                         @"Event "
                                         @"posted "
                                         @"successfu"
                                         @"lly"];
                                    }];
                               }
                           }];
                      }
                  }];
             } else {
                 [APPDelegate stopLoadingView];
                 [self
                  showAlertWithMessage:@"Something went wrong, Try again"];
             }
         }];
    } else {
        [ServiceManager
         createEvent:event
         forUser:ServiceManager.loggedUser
         onCompletion:^(BOOL success, NSString *eventId) {
             [APPDelegate stopLoadingView];
             if (success) {
                 [self
                  dismissViewControllerAnimated:YES
                  completion:^{
                      [APPDelegate
                       showAlertWithMessage:@"Event posted "
                       @"successfully"];
                  }];
             } else {
                 [self showAlertWithMessage:@"Something went wrong, Try again"];
             }
             
         }];
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

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:string];
    
    if (textField == _txtEventName) {
        return text.length <= 80;
    } else if (textField == _txtFees) {
        return ([self numberValidation:text] && text.length <= 4);
    } else if (textField == _txtAgerestriction) {
        return ([self numberValidation:text] && text.length <= 2);
    }
    
    return YES;
}

- (BOOL)numberValidation:(NSString *)text {
    NSString *regex = @"^([0-9]*|[0-9]*[.][0-9]*)$";
    NSPredicate *test =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [test evaluateWithObject:text];
    return isValid;
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    if ([textField isEqual:_txtCategory]) {
        [ActionSheetStringPicker showPickerWithTitle:@"Select Category"
                                                rows:[ServiceManager.sections valueForKey:@"name"]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex,
                                                       id selectedValue) {
                                               section = ServiceManager.sections[selectedIndex];
                                               _txtCategory.text = section.name;
                                               event.section = section;
                                           }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             
                                         }
                                              origin:textField];
        return NO;
    } else {
        if ([textField isEqual:_txtEndDate] || [textField isEqual:_txtStartDate]) {
            [ActionSheetDatePicker
             showPickerWithTitle:textField.placeholder
             datePickerMode:UIDatePickerModeDate
             selectedDate:[NSDate date]
             minimumDate:[NSDate date]
             maximumDate:nil
             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate,
                         id origin) {
                 NSDateFormatter *df = [NSDateFormatter new];
                 [df setDateFormat:@"dd-MM-yyyy"];
                 textField.text = [df stringFromDate:selectedDate];
                 if ([textField isEqual:_txtEndDate]) {
                     event.endDate = selectedDate;
                 } else {
                     event.startDate = selectedDate;
                 }
             }
             cancelBlock:nil
             origin:textField];
            return NO;
        } else if ([textField isEqual:_txtEndTime] ||
                   [textField isEqual:_txtStartTime]) {
            
            [ActionSheetDatePicker
             showPickerWithTitle:textField.placeholder
             datePickerMode:UIDatePickerModeTime
             selectedDate:[NSDate date]
             minimumDate:[NSDate date]
             maximumDate:nil
             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate,
                         id origin) {
                 NSDateFormatter *df = [NSDateFormatter new];
                 [df setDateFormat:@"hh:mm a"];
                 textField.text =
                 [df stringFromDate:selectedDate].lowercaseString;
                 
                 if ([textField isEqual:_txtStartTime]) {
                     event.startTime = selectedDate;
                 } else {
                     event.endTime = selectedDate;
                 }
             }
             cancelBlock:nil
             origin:textField];
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)closePressed:(id)sender {
    APPDelegate.tabBarController.customTabbar.hidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
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
                                 cip.lblHeader.text = @"Events";
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
                                                          [_colImages reloadData];
                                                          _colImages.hidden = NO;
                                                          _colPhotosHeightConstraint.constant = 120;
                                                          dispatch_after(
                                                                         dispatch_time(DISPATCH_TIME_NOW,
                                                                                       (int64_t)(0.2 * NSEC_PER_SEC)),
                                                                         dispatch_get_main_queue(), ^{
                                                                             [UIView
                                                                              animateWithDuration:0.2
                                                                              animations:^{
                                                                                  [_scrollView
                                                                                   setContentOffset:
                                                                                   CGPointMake(
                                                                                               0,
                                                                                               _scrollView.contentSize
                                                                                               .height -
                                                                                               _scrollView.frame
                                                                                               .size.height)];
                                                                              }];
                                                                             
                                                                         });
                                                      }
                                                      
                                                      if (arrayOfImages.count == 0) {
                                                          _colPhotosHeightConstraint.constant = 0;
                                                          _colImages.hidden = YES;
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

- (NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView {
    
    return 1;
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
    [_colImages reloadData];
    if (arrUrls.count == 0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        _colImages.hidden = YES;
        _colPhotosHeightConstraint.constant = 0;
    }
}

@end
