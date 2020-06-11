//
//  UIView+Animation.m
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:nil];
}

- (void) downUnder:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
         animations:^{
             self.transform = CGAffineTransformRotate(self.transform, M_PI);
         }
         completion:nil];
}

- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option
{
    // first reduce the view to 1/100th of its original dimension
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    view.transform = trans;	// do it instantly, no animation
    [self addSubview:view];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.0 options:option
        animations:^{
            view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);
        }
        completion:nil];	
}

- (void) removeWithZoomOutAnimation:(float)secs option:(UIViewAnimationOptions)option
{
	[UIView animateWithDuration:secs delay:0.0 options:option
    animations:^{
        self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
    }
    completion:^(BOOL finished) { 
        [self removeFromSuperview];
    }];
}

// add with a fade-in effect
- (void) addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option
{
	view.alpha = 0.0;	// make the view transparent
	[self addSubview:view];	// add it
	[UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{view.alpha = 1.0;}
                     completion:nil];	// animate the return to visible 
}

// remove self making it "drain" from the sink!
- (void) removeWithSinkAnimation:(int)steps
{
	NSTimer *timer;
	if (steps > 0 && steps < 100)	// just to avoid too much steps
		self.tag = steps;
	else
		self.tag = 50;
	timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(removeWithSinkAnimationRotateTimer:) userInfo:nil repeats:YES];
}
- (void) removeWithSinkAnimationRotateTimer:(NSTimer*) timer
{
	CGAffineTransform trans = CGAffineTransformRotate(CGAffineTransformScale(self.transform, 0.9, 0.9),0.314);
	self.transform = trans;
	self.alpha = self.alpha * 0.98;
	self.tag = self.tag - 1;
	if (self.tag <= 0)
	{
		[timer invalidate];
		[self removeFromSuperview];
	}
}

-(void)popOutWithAnimation:(float)animationDuration withDelay:(float)delayFactor
{
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animationDuration delay:delayFactor options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}


-(void)popInWithAnimation:(float)animationDuration withDelay:(float)delayFactor
{
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:animationDuration delay:delayFactor options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}


-(void)slideWithX:(int)x withY:(int)y andAnimation:(float)animation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animation];
    CGRect rect = [self frame];
    rect.origin.x = x;
    rect.origin.y = y;
    [self setFrame:rect];
    [UIView commitAnimations];
}


-(void)increaseFrameWithWidth:(int)w withHeight:(int)h andAnimation:(float)animation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animation];
    CGRect rect = [self frame];
    rect.size.width = w;
    rect.size.height = h;
    [self setFrame:rect];
    [UIView commitAnimations];
}

@end
