//
//  IGLabel.m
//  LinkUpNow
//
//  Created by Vikas Singh on 19/01/17.
//  Copyright © 2017 iGlobsyn Technologies. All rights reserved.
//

#import "IGLabel.h"

@implementation IGLabel

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
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
    
}

-(void)layoutSubviews{
    [self customInit];
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self customInit];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
