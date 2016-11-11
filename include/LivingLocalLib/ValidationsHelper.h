//
//  ValidationsHelper.h
//  SecurityMammal
//
//  Created by techloverr on 01/05/15.
//  Copyright (c) 2015 iTechCoderz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ValidationsHelper : NSObject

#pragma mark - Text Field Empty Validations
+ (BOOL)textFieldEmptyValidationsForTextFields:(NSArray *)arrayTextFields;

+ (BOOL)isGivenEmailValid:(NSString *)checkString;

+ (BOOL)isGivenPairOfPasswordsValid:(NSArray *)arrayPasswords;

+ (void)showAlertWithMessage:(NSString *)message;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

+ (void)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                     buttons:(NSArray *)arrActions
                    fromView:(UIView *)view
           completionHandler:
(void (^)(UIAlertController *, NSInteger))completionHandler;

+ (void)alertControllerWithTitle:(NSString *)title
                         message:(NSString *)message
                         buttons:(NSArray *)arrActions
               completionHandler:
(void (^)(UIAlertController *, NSInteger))completionHandler;

@end
