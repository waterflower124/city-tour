//
//  Constants.h
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define appNAME  @"CityBud"

#import "MBProgressHUD.h"
#import "MFSideMenu.h"

#import "kzTextField.h"
#import "UIScrollView+EmptyDataSet.h"

#import "MFSideMenuContainerViewController.h"
#import "WDHTTPClient.h"
#import "WDWebserviceHelper.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "USUserInfoModel.h"

/*---------------Categories---------------*/
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+animatedGIF.h"
#import "UIKit+AFNetworking.h"
#import "NSDate+CustomDateMethods.h"
#import "NSError+CustomErrors.h"
#import "NSException+ExceptionToError.h"
#import "UIView+Animation.h"
#import "NSString+CustomMethods.h"
#import "UIBarButtonItem+BackButton.h"
#import "UIAlertController+CustomMethods.h"
#import "CIImage+Convenience.h"
#import "UICollectionView+Convenience.h"
#import "NSIndexSet+Convenience.h"


#define SCREEN_WINDOW                   [[[UIApplication sharedApplication] delegate] window]
#define HIDE_LOADING()                  [MBProgressHUD hideHUDForView:SCREEN_WINDOW animated:YES]
#define SHOW_LOADING()                  [MBProgressHUD showHUDAddedTo:SCREEN_WINDOW animated:NO]

#define IS_NETWORK_AVAILABLE()  (BOOL)([AFNetworkReachabilityManager sharedManager].reachable <= 0 ? NO : YES)

#define SHOW_NETWORK_ERROR_ALERT() [UIAlertController showAlertWithTitle:@"Error" message:@"Network Connection Not Available" onViewController:self];


/*-----Font -----*/

#define Helvetica                                  @"Helvetica"
#define HelveticaLight                             @"Helvetica-Light"
#define HelveticaLightOblique                      @"Helvetica-LightOblique"
#define HelveticaOblique                           @"Helvetica-Oblique"
#define HelveticaBoldOblique                       @"Helvetica-BoldOblique"
#define HelveticaBold                              @"Helvetica-Bold"

#define FONT_Regular(v)         [UIFont fontWithName:@"Lato-Regular"     size:v]
#define FONT_Italic(v)          [UIFont fontWithName:@"Lato-Italic"     size:v]

#define FONT_Bold(v)            [UIFont fontWithName:@"Lato-Bold"       size:v]
#define FONT_BoldItalic(v)      [UIFont fontWithName:@"Lato-BoldItalic"       size:v]

#define FONT_Light(v)           [UIFont fontWithName:@"Lato-Light"    size:v]
#define FONT_LightItalic(v)     [UIFont fontWithName:@"Lato-LightItalic"   size:v]

#define cityBudBlueColor [UIColor colorWithRed:0.11 green:0.31 blue:0.51 alpha:1.0]

/*-----KeyBoard slider code-----*/


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;//216
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

/*-----------------------*/

/*---------CHECK STRING -------------*/
#define IS_VALID_STRING(_str_) _str_ && ![_str_ isEqual:[NSNull null]] && ![_str_ isEqualToString:@"(null)"]  ? TRUE : FALSE

#define IS_VALID_STRINGS(_str_) _str_ && ![_str_ isEqual:[NSNull null]] && ![_str_ isEqualToString:@"(null)"]

#define GET_VALID_STRING(_str_) _str_ && ![_str_ isEqualToString:@"(null)"] && ![_str_ isEqual:[NSNull null]]  ? _str_ : @""
 /*----------------------------------*/

//Client's server url
//http://socialbud.imvisile.com/api/users/

#define BaseLink @"http://citybudng.com/citybud/api/users/"

#pragma mark - Application Delegate
#import "AppDelegate.h"
#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define IS_IPHONE4_OR_4S [[UIScreen mainScreen] bounds].size.height == 480.0f
#define IS_IPHONE5_OR_5S [[UIScreen mainScreen] bounds].size.height == 568.0f
#define IS_IPHONE6 [[UIScreen mainScreen] bounds].size.height == 667.0f
#define IS_IPHONE6pluse [[UIScreen mainScreen] bounds].size.height == 736.0f

#endif /* Constants_h */
