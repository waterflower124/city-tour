//
//  VBButton.h
//  Tradesman
//
//  Created by Cromosys on 07/12/15.
//  Copyright © 2015 Pvb. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface iGButton : UIButton

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end
