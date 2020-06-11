//
//  VBButton.m
//  Tradesman
//
//  Created by Cromosys on 07/12/15.
//  Copyright © 2015 Pvb. All rights reserved.
//

#import "iGButton.h"

@implementation iGButton

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

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self customInit];
}



@end
