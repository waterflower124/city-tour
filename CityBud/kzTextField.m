//
//  kzTextField.m
//  Kagazz
//
//  Created by Ajay Chaudhary on 8/10/15.
//  Copyright (c) 2015 Imvisile Solution. All rights reserved.
//

#import "kzTextField.h"
#import "SSDrawingUtilities.h"

@interface kzTextField ()
- (void)_initialize;
@end


@implementation kzTextField

#pragma mark - Accessors

@synthesize textEdgeInsets = _textEdgeInsets;
@synthesize clearButtonEdgeInsets = _clearButtonEdgeInsets;
@synthesize placeholderTextColor = _placeholderTextColor;

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = placeholderTextColor;
    
    if (!self.text && self.placeholder) {
        [self setNeedsDisplay];
    }
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self _initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}


#pragma mark - UITextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (_textEdgeInsets.left==0) {
        _textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], _textEdgeInsets);
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return [self textRectForBounds:bounds];
}


- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect rect = [super clearButtonRectForBounds:bounds];
    rect = CGRectSetY(rect, rect.origin.y + _clearButtonEdgeInsets.top);
    return CGRectSetX(rect, rect.origin.x + _clearButtonEdgeInsets.right);
}


- (void)drawPlaceholderInRect:(CGRect)rect {
    if (!_placeholderTextColor) {
        [super drawPlaceholderInRect:rect];
        return;
    }
    
    [_placeholderTextColor setFill];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
#else
    [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
#endif
}


#pragma mark - Private

- (void)_initialize {
    _textEdgeInsets = UIEdgeInsetsZero;
    _clearButtonEdgeInsets = UIEdgeInsetsZero;
}

@end
