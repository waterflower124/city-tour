//
//  UIAlertController+CustomMethods.m
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import "UIAlertController+CustomMethods.h"

@implementation UIAlertController (CustomMethods)

+ (UIAlertController*)alertControllerWithTitle:(NSString *)title
                                       message:(NSString *)message
                                   buttonTitle:(NSString *) buttonTitle
                                viewController:(UIViewController *)viewController
                                   alertAction:(alertClicked)aBlock;
{
    __block alertClicked localBlock = [aBlock copy];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   localBlock(action);
                                                   localBlock = nil;
                                               }];
    [alert addAction:ok];
    
    [viewController presentViewController:alert animated:YES completion:nil];
    return alert;
}


+ (UIAlertController*)sheetControllerWithTitle:(NSString *)aTitle
                                       message:(NSString *)aMessage
                                       actions:(UIAlertAction *)cancelAct, ...
{
    va_list args;
    va_start(args, cancelAct);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:aTitle
                                                                   message:aMessage
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (UIAlertAction *anAct = cancelAct; anAct != nil; anAct = va_arg(args, UIAlertAction*))
    {
        [alert addAction:anAct];
    }
    va_end(args);
    return alert;
}
+(void) showAlertWithTitle:(NSString *)title message:(NSString *)message onViewController:(UIViewController *)vc
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        [alert addAction:ok];
        
        [vc presentViewController:alert animated:YES completion:nil];
    });
    
}

@end
