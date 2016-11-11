//
//  CreatePostViewController.h
//  FeedApp
//
//  Created by TechLoverr on 08/09/16.
//
//

#import <UIKit/UIKit.h>
#import "LLButton.h"

@interface CreatePostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnAddPhotos;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@property (weak, nonatomic) IBOutlet LLLabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *ingUser;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommendationHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *txtPost;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet LLButton *btnRecommendation;
@property (strong, nonatomic) LLSection *section;
@property (strong, nonatomic) LLGroup *group;
@end

@interface CustomImageCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewCollectionThumb;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteImage;

@end
