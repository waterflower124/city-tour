//
//  UIView+Animation.h
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) downUnder:(float)secs option:(UIViewAnimationOptions)option;
- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) removeWithZoomOutAnimation:(float)secs option:(UIViewAnimationOptions)option;
- (void) addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) removeWithSinkAnimation:(int)steps;
- (void) removeWithSinkAnimationRotateTimer:(NSTimer*) timer;
- (void) popOutWithAnimation:(float)animationDuration withDelay:(float)delayFactor;
- (void) popInWithAnimation:(float)animationDuration withDelay:(float)delayFactor;
- (void) slideWithX:(int)x withY:(int)y andAnimation:(float)animation;
- (void) increaseFrameWithWidth:(int)w withHeight:(int)h andAnimation:(float)animation;

@end
