//
//  iGMethod.h
//  CAndD
//
//  Created by Vikas Singh on 10/09/16.
//  Copyright © 2016 iGlobsyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "GIFProgressHUD.h"
//#import "RemoteImageView.h"
#define APPNAME @"LinkUpNow"

@interface STMethod : NSObject

+ (STMethod*)sharedInstance;

+(BOOL)stringIsEmptyOrNot:(NSString*)String;

+(BOOL)validateTextFieldEmpty:(NSString*)text;

+ (BOOL)validateEmailWithString:(NSString*)emailText;

+(BOOL)validatePhoneWithString:(NSString*)phoneText;

+ (BOOL)validatePasswordWithString:(NSString*)passwordText;

+ (BOOL)validateConfirmPasswordString:(NSString*)passwordText ConfirmPassword:(NSString*)confirmPasswordText;
+ (BOOL) validateUrl: (NSString *) website;

+(void)fixHeightOfThisLabel:(UILabel *)aLabel;

+(CGFloat)heightOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize;

+(void)fixWidthOfThisLabel:(UILabel *)aLabel;

+(CGFloat)widthOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize;

+(void)setButtonRoundRectAndBorderButton:(UIButton*)Button CornerRect:(CGFloat)Rect Bound:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor;

+(void)setTextFieldRoundRectAndBorderButton:(UITextField*)TextField CornerRect:(CGFloat)Rect Bound:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor;

+(void)setTextViewRoundRectAndBorderButton:(UITextView*)TextView CornerRect:(CGFloat)Rect Bound:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor;

//+(void)setImageViewRoundRectAndBorderImageView:(RemoteImageView*)ImageView CornerRect:(CGFloat)Rect Bound:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor;

+(void)setViewRoundRectAndBorderView:(UIView*)View CornerRect:(CGFloat)Rect Bound:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor;

+(void)showToastMessageWithTitle:(NSString *)Title Message:(NSString*)Message inView:(UIView*)view Animation:(BOOL)animate;

+(void)internetAlert:(UIViewController*)ViewController;

+(void)connectionFailAlert:(UIViewController*)ViewController;

+(void)serverBusyAlert:(UIViewController*)ViewController;

+(void)showAlert:(UIViewController*)ViewController Title:(NSString*)Title Message:(NSString*)Message ButtonTitle:(NSString*)ButtonTitle;

+(void)showInternetToast:(UIView*)view;

+(void)setViewRoundRectAndBorderViewAndShadow:(UIView*)View CornerRadius:(CGFloat)Radius Round:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor ShadowOrNot:(BOOL)ShadowOrNot ShadowColor:(UIColor*)shadowColor ShadowOpacity:(CGFloat)Opacity ShadowRadius:(CGFloat)SRadius ShadowOffset:(CGSize)Offset;

+(void)showServerBusyToast:(UIView*)view;

+(void)showConnectionFailToast:(UIView*)view;

+ (NSString *)dateStringFromString:(NSString *)sourceString destinationFormat:(NSString *)destinationFormat;

+ (UITextField *)changePlaceHolderPosition:(UITextField *)txtField ViewWidth:(CGFloat)W ViewHeight:(CGFloat)H;

+(void)setLableUnderline:(NSString*)AllString FontColor:(UIColor*)Color FontName:(UIFont*)Font UnderLineColor:(UIColor*)ULineColor ForLabel:(UILabel*)Label;

+(void)attributedString:(NSString*)AllStr FirstStr:(NSString*)Fstr  FirstStrFont:(UIFont*)FFont  FirstStrColor:(UIColor*)FColor SecondStr:(NSString*)Sstr  SecondStrFont:(UIFont*)SFont  SecondStrColor:(UIColor*)SColor ThirdStr:(NSString*)Tstr  ThirdStrFont:(UIFont*)TFont  ThirdStrColor:(UIColor*)TColor FourthStr:(NSString*)Fostr  FourthStrFont:(UIFont*)FoFont  FourthStrColor:(UIColor*)FoColor ForLable:(UILabel*)Lable;

typedef enum {
    TYPE_INTEGER=0,
    TYPE_DATE,
    TYPE_ALPHABET
}KeyType_t;

+ (void) sortArrayofDictonary:(NSMutableArray*)orginalArray withKey:(NSString*)keyValue keyType:(KeyType_t)keytype ToAscending:(BOOL)isAscending;

@end

