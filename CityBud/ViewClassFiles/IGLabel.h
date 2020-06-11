//
//  IGLabel.h
//  LinkUpNow
//
//  Created by Vikas Singh on 19/01/17.
//  Copyright © 2017 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface IGLabel : UILabel

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;


@end
