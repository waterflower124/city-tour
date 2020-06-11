//
//  iGMethod.m
//  CAndD
//
//  Created by Vikas Singh on 10/09/16.
//  Copyright © 2016 iGlobsyn. All rights reserved.
//

#import "STMethod.h"

@implementation STMethod

+ (STMethod*)sharedInstance
{
    static STMethod *_sharedInstance = nil;
    
    _sharedInstance = [[STMethod alloc] init];
    
    return _sharedInstance;
}
#pragma mark - String Is Empty,Null OR Not

+(BOOL)stringIsEmptyOrNot:(NSString*)String
{
    NSString *TempSTR=String;
    
    TempSTR=[TempSTR stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([String isKindOfClass:[NSNull class]] || [String isEqualToString:@"(null)"] || [String isEqualToString:@"<null>"] || !([String length]>0) || [String isEqualToString:@"null"] || [String isEqualToString:@"NULL"] || [String isEqualToString:@"<NULL>"] || [String isEqualToString:@"(NULL)"])
    {
        return true;
    }
    
    if ([TempSTR isKindOfClass:[NSNull class]] || [TempSTR isEqualToString:@"(null)"] || [TempSTR isEqualToString:@"<null>"] || !([TempSTR length]>0) || [TempSTR isEqualToString:@"null"] || [TempSTR isEqualToString:@"NULL"] || [TempSTR isEqualToString:@"<NULL>"] || [TempSTR isEqualToString:@"(NULL)"])
    {
        return true;
    }
    else
    {
        return false;
    }
}

#pragma mark - Textfield Is Empty OR Not

+(BOOL)validateTextFieldEmpty:(NSString*)text
{
    if (text.length > 0)
    {
        return YES;
    }
    return NO;
}

#pragma mark - Valid Email ID OR Not

+ (BOOL)validateEmailWithString:(NSString*)emailText
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailText];
}

#pragma mark - Valid PhoneNumber OR Not

+(BOOL)validatePhoneWithString:(NSString*)phoneText
{
    NSString *mobileNumberPattern = @"[789][0-9]{9}";
    NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
    
    return [mobileNumberPred evaluateWithObject:phoneText];
}

#pragma mark - Valid Password OR Not

+ (BOOL)validatePasswordWithString:(NSString*)passwordText
{
    if ([passwordText length]<3 || [passwordText length]>20)
        return NO;
    else
        return YES;
}

// *** Validation for Password ***

// "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$" --> (Minimum 8 characters at least 1 Alphabet and 1 Number)
// "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,16}$" --> (Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character)
// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number)
// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)
// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,10}" --> (Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)


-(BOOL)isValidPassword:(NSString *)passwordString
{
    NSString *stricterFilterString = @"^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [passwordTest evaluateWithObject:passwordString];
}

#pragma mark - Valid Conform Password OR Not

+ (BOOL)validateConfirmPasswordString:(NSString*)passwordText ConfirmPassword:(NSString*)confirmPasswordText
{
    if ((passwordText.length > 0 && confirmPasswordText.length > 0) && [passwordText isEqualToString:confirmPasswordText])
    {
        return YES;
    }
    return NO;
}

#pragma mark - Valid URl OR not

+ (BOOL) validateUrl: (NSString *) website
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    
    return [urlTest evaluateWithObject:website];
}

#pragma mark - Set Hieght for Lable

+(void)fixHeightOfThisLabel:(UILabel *)aLabel
{
    aLabel.frame = CGRectMake(aLabel.frame.origin.x,
                              aLabel.frame.origin.y,
                              aLabel.frame.size.width,
                              [self heightOfTextForString:aLabel.text
                                                  andFont:aLabel.font
                                                  maxSize:CGSizeMake(aLabel.frame.size.width, MAXFLOAT)]);
}

#pragma mark - Calculate Maximum Height For Lable

+(CGFloat)heightOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize
{
    // iOS7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGSize sizeOfText = [aString boundingRectWithSize: aSize
                                                  options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes: [NSDictionary dictionaryWithObject:aFont
                                                                                       forKey:NSFontAttributeName]
                                                  context: nil].size;
        return ceilf(sizeOfText.height);
    }
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary * attributes = @{NSFontAttributeName:aFont,
                                  NSParagraphStyleAttributeName:paragraphStyle
                                  };
    
    CGRect textRect = [aString boundingRectWithSize:aSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
    CGSize textSize = textRect.size;
    return ceilf(textSize.height);
}

#pragma mark - Set Hieght for Lable

+(void)fixWidthOfThisLabel:(UILabel *)aLabel
{
    aLabel.frame = CGRectMake(aLabel.frame.origin.x,
                              aLabel.frame.origin.y,
                              [self widthOfTextForString:aLabel.text
                                                 andFont:aLabel.font
                                                 maxSize:CGSizeMake(MAXFLOAT, aLabel.frame.size.height)],
                              aLabel.frame.size.height);
}

#pragma mark - Calculate Maximum Width For Lable

+(CGFloat)widthOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize
{
    // iOS7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGSize sizeOfText = [aString boundingRectWithSize: aSize
                                                  options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes: [NSDictionary dictionaryWithObject:aFont
                                                                                       forKey:NSFontAttributeName]
                                                  context: nil].size;
        
        return ceilf(sizeOfText.width);
    }
    
    // iOS6
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary * attributes = @{NSFontAttributeName:aFont,
                                  NSParagraphStyleAttributeName:paragraphStyle
                                  };
    
    CGRect textRect = [aString boundingRectWithSize:aSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
    CGSize textSize = textRect.size;
    
    return ceilf(textSize.width);
}

#pragma mark - set Button RoundRectAndBorder

+(void)setButtonRoundRectAndBorderButton:(UIButton*)Button CornerRect:(CGFloat)Rect Bound:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor
{
    Button.layer.borderWidth=Width;
    Button.layer.borderColor=BorderColor.CGColor;
    Button.layer.cornerRadius=Rect;
    Button.clipsToBounds=RoundOrNot;
}

#pragma mark - set UIView RoundRectAndBorder

+(void)setViewRoundRectAndBorderView:(UIView*)View CornerRect:(CGFloat)Rect Bound:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor
{
    View.layer.borderWidth=Width;
    View.layer.borderColor=BorderColor.CGColor;
    View.layer.cornerRadius=Rect;
    View.clipsToBounds=RoundOrNot;
}

#pragma mark - set TextView RoundRectAndBorder

+(void)setTextViewRoundRectAndBorderButton:(UITextView*)TextView CornerRect:(CGFloat)Rect Bound:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor
{
    TextView.layer.borderWidth=Width;
    TextView.layer.borderColor=BorderColor.CGColor;
    TextView.layer.cornerRadius=Rect;
    TextView.clipsToBounds=RoundOrNot;
}

//#pragma mark - set ImageView RoundRectAndBorder
//+(void)setImageViewRoundRectAndBorderImageView:(RemoteImageView*)ImageView CornerRect:(CGFloat)Rect Bound:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor
//{
//    ImageView.layer.borderWidth=Width;
//    ImageView.layer.borderColor=BorderColor.CGColor;
//    ImageView.layer.cornerRadius=Rect;
//    ImageView.clipsToBounds=RoundOrNot;
//}

#pragma mark - set TextField RoundRectAndBorder

+(void)setTextFieldRoundRectAndBorderButton:(UITextField*)TextField CornerRect:(CGFloat)Rect Bound:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor
{
    TextField.layer.borderWidth=Width;
    TextField.layer.borderColor=BorderColor.CGColor;
    TextField.layer.cornerRadius=Rect;
    TextField.clipsToBounds=RoundOrNot;
}


#pragma mark - set UIview shadow & corner

+(void)setViewRoundRectAndBorderViewAndShadow:(UIView*)View CornerRadius:(CGFloat)Radius Round:(BOOL)RoundOrNot BorderWidth:(CGFloat)Width BorderColor:(UIColor*)BorderColor ShadowOrNot:(BOOL)ShadowOrNot ShadowColor:(UIColor*)shadowColor ShadowOpacity:(CGFloat)Opacity ShadowRadius:(CGFloat)SRadius ShadowOffset:(CGSize)Offset
{
    if (RoundOrNot)
    {
        [[View layer] setCornerRadius:Radius];
    }
    
    if (ShadowOrNot)
    {
        [[View layer] setShadowOpacity:Opacity];
        [[View layer] setShadowColor:shadowColor.CGColor];
        [[View layer] setShadowRadius:SRadius];
        [[View layer] setShadowOffset:Offset];
    }
    
    [[View layer] setBorderWidth:Width];
    [[View layer] setBorderColor:BorderColor.CGColor];
}


//+(void)internetAlert:(UIViewController*)ViewController
//{
//    UIAlertController * alert= [UIAlertController alertControllerWithTitle:APPNAME message:@"Please check and verify that you have Internet access." preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){[alert dismissViewControllerAnimated:YES completion:nil];}];
//    [alert addAction:ok];
//    [ViewController presentViewController:alert animated:YES completion:nil];
//}

//+(void)connectionFailAlert:(UIViewController*)ViewController
//{
//    UIAlertController * alert= [UIAlertController alertControllerWithTitle:APPNAME message:@"Please Make a Connection And Try Again." preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){[alert dismissViewControllerAnimated:YES completion:nil];}];
//    [alert addAction:ok];
//    [ViewController presentViewController:alert animated:YES completion:nil];
//}

//+(void)serverBusyAlert:(UIViewController*)ViewController
//{
//    UIAlertController * alert= [UIAlertController alertControllerWithTitle:APPNAME message:@"Our server is being updated at the moment.  We apologize for the inconvenience.  It should be up shortly.  Please try again later." preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){[alert dismissViewControllerAnimated:YES completion:nil];}];
//    [alert addAction:ok];
//    [ViewController presentViewController:alert animated:YES completion:nil];
//}

+(void)showAlert:(UIViewController*)ViewController Title:(NSString*)Title Message:(NSString*)Message ButtonTitle:(NSString*)ButtonTitle
{
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:Title message:Message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:ButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [ViewController presentViewController:alert animated:YES completion:nil];
}

+(void)setLableUnderline:(NSString*)AllString FontColor:(UIColor*)Color FontName:(UIFont*)Font UnderLineColor:(UIColor*)ULineColor ForLabel:(UILabel*)Label
{
    NSString *Str=AllString;
    
    if ([Label respondsToSelector:@selector(setAttributedText:)])
    {
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: Label.textColor,
                                  NSFontAttributeName: Label.font
                                  };
        
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:Str
                                               attributes:attribs];
        
        NSRange redTextRange = [Str rangeOfString:Str];
        
        [attributedText setAttributes:@{NSForegroundColorAttributeName:Color,NSFontAttributeName:Font}
                                range:redTextRange];
        
        [attributedText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:redTextRange];
        
        [attributedText addAttribute:NSUnderlineColorAttributeName value:ULineColor range:redTextRange];
        
        Label.attributedText=attributedText;
    }
    else
    {
        Label.text = AllString;
    }
}

+(void)attributedString:(NSString*)AllStr FirstStr:(NSString*)Fstr  FirstStrFont:(UIFont*)FFont  FirstStrColor:(UIColor*)FColor SecondStr:(NSString*)Sstr  SecondStrFont:(UIFont*)SFont  SecondStrColor:(UIColor*)SColor ThirdStr:(NSString*)Tstr  ThirdStrFont:(UIFont*)TFont  ThirdStrColor:(UIColor*)TColor FourthStr:(NSString*)Fostr  FourthStrFont:(UIFont*)FoFont  FourthStrColor:(UIColor*)FoColor ForLable:(UILabel*)Lable
{
    NSString *redText = Fstr;
    NSString *greenText = Sstr;
    NSString *purpleBoldText = Tstr;
    NSString *GrayText = Fostr;
    
    NSString *text = AllStr;
    
    // If attributed text is supported (iOS6+)
    if ([Lable respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: Lable.textColor,
                                  NSFontAttributeName: Lable.font
                                  };
        
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        
        // First text attributes
        
        NSRange redTextRange = [text rangeOfString:redText];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        [attributedText setAttributes:@{NSForegroundColorAttributeName:FColor,NSFontAttributeName:FFont}
                                range:redTextRange];
        
        // Second text attributes
        NSRange greenTextRange = [text rangeOfString:greenText];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        [attributedText setAttributes:@{NSForegroundColorAttributeName:SColor,NSFontAttributeName:SFont}
                                range:greenTextRange];
        
        //Third and bold text attributes
        NSRange purpleBoldTextRange = [text rangeOfString:purpleBoldText];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        [attributedText setAttributes:@{NSForegroundColorAttributeName:TColor,
                                        NSFontAttributeName:TFont}
                                range:purpleBoldTextRange];
        
        //Third and bold text attributes
        NSRange GrayTextRange = [text rangeOfString:GrayText];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        [attributedText setAttributes:@{NSForegroundColorAttributeName:FoColor,
                                        NSFontAttributeName:FoFont}
                                range:GrayTextRange];
        
        Lable.attributedText = attributedText;
    }
    // If attributed text is NOT supported (iOS5-)
    else {
        Lable.text = text;
    }
}

//#pragma mark- Toast Message Method
//+(void)showToastMessageWithTitle:(NSString *)Title Message:(NSString*)Message inView:(UIView*)view Animation:(BOOL)animate
//{
//    GIFProgressHUD *hud = [GIFProgressHUD showHUDWithTitle:Title detailTitle:Message addedToView:view animated:animate];
//    
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
//    {
//        hud.titleFont= [UIFont fontWithName:@"HelveticaNeue" size:12];
//    }
//    else
//    {
//        hud.titleFont= [UIFont fontWithName:@"HelveticaNeue" size:9.5];
//    }
//    
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        [hud wait];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideWithAnimation:YES];
//        });
//    });
//}

//+(void)showInternetToast:(UIView*)view
//{
//    GIFProgressHUD *hud = [GIFProgressHUD showHUDWithTitle:APPNAME detailTitle:@"Please check and verify that you have Internet access." addedToView:view animated:YES];
//    
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
//    {
//        hud.titleFont= [UIFont fontWithName:@"HelveticaNeue" size:12];
//    }
//    else
//    {
//        hud.titleFont= [UIFont fontWithName:@"HelveticaNeue" size:9.5];
//    }
//    
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        [hud wait];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideWithAnimation:YES];
//        });
//    });
//}
//
//+(void)showServerBusyToast:(UIView*)view
//{
//    GIFProgressHUD *hud = [GIFProgressHUD showHUDWithTitle:APPNAME detailTitle:@"Our server is being updated at the moment.  We apologize for the inconvenience.  It should be up shortly.  Please try again later." addedToView:view animated:YES];
//    
//    
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
//    {
//        hud.titleFont= [UIFont fontWithName:@"HelveticaNeue" size:12];
//    }
//    else
//    {
//        hud.titleFont= [UIFont fontWithName:@"HelveticaNeue" size:9.5];
//    }
//    
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        [hud wait];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideWithAnimation:YES];
//        });
//    });
//}

//+(void)showConnectionFailToast:(UIView*)view
//{
//    GIFProgressHUD *hud = [GIFProgressHUD showHUDWithTitle:APPNAME detailTitle:@"Please Make a Connection And Try Again." addedToView:view animated:YES];
//    
//    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
//    {
//        hud.titleFont= [UIFont fontWithName:@"HelveticaNeue" size:12];
//    }
//    else
//    {
//        hud.titleFont= [UIFont fontWithName:@"HelveticaNeue" size:9.5];
//    }
//    
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        [hud wait];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideWithAnimation:YES];
//        });
//    });
//}

+ (NSString *)dateStringFromString:(NSString *)sourceString destinationFormat:(NSString *)destinationFormat
{
    NSString *convertedDateString = nil;
    NSArray *dateFormatterList = [NSArray arrayWithObjects:@"yyyy-MM-dd'T'HH:mm:ss'Z'", @"yyyy-MM-dd'T'HH:mm:ssZ",
                                  @"yyyy-MM-dd'T'HH:mm:ss", @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                  @"yyyy-MM-dd'T'HH:mm:ss.SSSZ", @"yyyy-MM-dd HH:mm:ss",
                                  @"MM/dd/yyyy HH:mm:ss", @"MM/dd/yyyy'T'HH:mm:ss.SSS'Z'",
                                  @"MM/dd/yyyy'T'HH:mm:ss.SSSZ", @"MM/dd/yyyy'T'HH:mm:ss.SSS",
                                  @"MM/dd/yyyy'T'HH:mm:ssZ", @"MM/dd/yyyy'T'HH:mm:ss",
                                  @"yyyy:MM:dd HH:mm:ss", @"yyyyMMdd", @"dd-MM-yyyy",
                                  @"dd/MM/yyyy", @"yyyy-MM-dd", @"yyyy/MM/dd",
                                  @"dd MMMM yyyy", @"MMddyyyy", @"MM/dd/yyyy",
                                  @"MM-dd-yyyy", @"d'st' MMMM yyyy",
                                  @"d'nd' MMMM yyyy", @"d'rd' MMMM yyyy",
                                  @"d'th' MMMM yyyy", @"d'st' MMM yyyy",
                                  @"d'nd' MMM yyyy", @"d'rd' MMM yyyy",
                                  @"d'th' MMM yyyy", @"d'st' MMMM",
                                  @"d'nd' MMMM", @"d'rd' MMMM",
                                  @"d'th' MMMM", @"d'st' MMM",
                                  @"d'nd' MMM", @"d'rd' MMM",
                                  @"d'th' MMM", @"MMMM, yyyy",
                                  @"MMMM yyyy", nil];
    
    //sourceString = @"20/11/2012";
    //destinationFormat  = @"dd MMMM yyyy";
    
    if (sourceString)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        for (NSString *dateFormatterString in dateFormatterList) {
            
            [dateFormatter setDateFormat:dateFormatterString];
            NSDate *originalDate = [dateFormatter dateFromString:sourceString];
            
            if (originalDate)
            {
                [dateFormatter setDateFormat:destinationFormat];
                convertedDateString = [dateFormatter stringFromDate:originalDate];
                NSLog(@"Converted date String is %@", convertedDateString);
                break;
            }
        }
    }
    return convertedDateString;
}

+ (UITextField *)changePlaceHolderPosition:(UITextField *)txtField ViewWidth:(CGFloat)W ViewHeight:(CGFloat)H
{
    txtField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, H)];
    txtField.leftViewMode = UITextFieldViewModeAlways;
    return txtField;
}

#pragma mark - Sort Array
+ (void) sortArrayofDictonary:(NSMutableArray*)orginalArray withKey:(NSString*)keyValue keyType:(KeyType_t)keytype ToAscending:(BOOL)isAscending {
    
    NSSortDescriptor *keyDescriptor;
    if (keytype == TYPE_INTEGER)
    {
        keyDescriptor = [NSSortDescriptor sortDescriptorWithKey:keyValue ascending:isAscending comparator:^(id obj1, id obj2) {
            
            if ([obj1 floatValue] > [obj2 floatValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 floatValue] < [obj2 floatValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
    }
    else if (keytype == TYPE_DATE)
    {
        // yyyy-MM-dd HH:mm:ss
        
        keyDescriptor = [NSSortDescriptor sortDescriptorWithKey:keyValue ascending:isAscending comparator:^(id obj1, id obj2)
        {
            //Convert NSString to NSDate:
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //Set the AM and PM symbols
            //[dateFormatter setAMSymbol:@"AM"];
            //[dateFormatter setPMSymbol:@"PM"];
            //Specify only 1 M for month, 1 d for day and 1 h for hour
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *d1 = [dateFormatter dateFromString:obj1];
            NSDate *d2 = [dateFormatter dateFromString:obj2];
            
            if ([d1 compare:d2] == NSOrderedAscending)
                return (NSComparisonResult)NSOrderedAscending;
            if ([d1 compare:d2] == NSOrderedDescending)
                return (NSComparisonResult)NSOrderedDescending;
            return (NSComparisonResult)NSOrderedSame;
        }];
    }
    else
    {
        keyDescriptor = [NSSortDescriptor sortDescriptorWithKey:keyValue ascending:isAscending];
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:keyDescriptor];
    NSArray *sortedArray = [orginalArray sortedArrayUsingDescriptors:sortDescriptors];
    
    [orginalArray removeAllObjects];
    
    for (int i=0; i<[sortedArray count]; i++)
    {
        [orginalArray addObject:[sortedArray objectAtIndex:i]];
    }
}

@end
