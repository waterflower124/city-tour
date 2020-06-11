//
//  iGTextView.h
//  Salton
//
//  Created by Apple on 23/02/17.
//  Copyright © 2017 iGlobsyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
IB_DESIGNABLE
@interface iGTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
