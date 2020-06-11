//
//  BVView.m
//  CustomeClasses
//
//  Created by Cromosys on 28/11/15.
//  Copyright © 2015 Pvb. All rights reserved.
//

#import "iGView.h"

@implementation iGView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    
    }
    return self;
}

-(void)customInit
{
    /// For Set CornerRadius
    self.layer.cornerRadius = self.cornerRadius;
    if (self.cornerRadius > 0)
    {
        self.layer.masksToBounds = YES;
    }
    
    /// For Set Border Width
    self.layer.borderWidth = self.borderWidth;
    
    /// For Set Border Color
    self.layer.borderColor = [self.borderColor CGColor];
 
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.bounds;
    
    gradient.colors = [NSArray arrayWithObjects:(id)[self.startColor CGColor],(id)[self.midColor CGColor], (id)[self.endColor CGColor], nil];
    
    gradient.endPoint = (self.isHorizontal) ? CGPointMake(1, 0) : CGPointMake(0, 1);
    
    [self.layer insertSublayer:gradient atIndex:0];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self customInit];
}


@end
