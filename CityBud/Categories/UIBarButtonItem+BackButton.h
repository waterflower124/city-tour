//
//  UIBarButtonItem+BackButton.h
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UIBarButtonItem (BackButton)

+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image title:(NSString *)title Target:(id)target action:(SEL)action;

@end

