//
//  UIBarButtonItem+BackButton.m
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//

#import "UIBarButtonItem+BackButton.h"

@implementation UIBarButtonItem (BackButton)

+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image title:(NSString *)title Target:(id)target action:(SEL)action
{
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:15.0f];

    if (image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        //set the frame of the button to the size of the image (see note below)
        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    
    if (title) {
        CGSize size = CGSizeMake(230, 100);
        UIFont *font = [UIFont fontWithName:@"Helvetica Bold" size:15.0f];
        
        CGRect textRect;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        textRect = [title boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
#else
        CGSize textSize = [title sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        textRect = CGRectMake(0, 0, textSize.width, textSize.height);
#endif
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, textRect.size.width, textRect.size.height);
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return customBarItem;
}

@end
