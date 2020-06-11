//
//  UIAlertController+CustomMethods.h
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIAlertController (CustomMethods)
typedef void (^alertClicked)(UIAlertAction *action);

+ (UIAlertController*)alertControllerWithTitle:(NSString *)title
                                       message:(NSString *)message
                                   buttonTitle:(NSString *) buttonTitle
                                viewController:(UIViewController *)viewController
                                   alertAction:(alertClicked)aBlock;


+ (UIAlertController*)sheetControllerWithTitle:(NSString *)aTitle
                                       message:(NSString *)aMessage
                                       actions:(UIAlertAction *)cancelAct, ...;
+(void) showAlertWithTitle:(NSString *)title message:(NSString *)message onViewController:(UIViewController *)vc;
@end
