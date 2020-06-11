//
//  CBLoginViewController.m
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//


#import "CBLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CBMenuViewController.h"
#import "CBSignupViewController.h"
#import "NSString+MD5.h"
#import <Social/Social.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
//#import <TwitterKit/TwitterKit.h>
#import <Twitter/Twitter.h>
#import <TwitterKit/TWTRKit.h>
#import <SafariServices/SafariServices.h>
#import "STMethod.h"



@interface CBLoginViewController (){
    CGFloat animatedDistance;
    NSString *str_UserName;
    UIView *viewPromoCode;
    UITextField *tfPromoCode;
    NSMutableDictionary *dictITSocialData;
}

@end

@implementation CBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)buttonLoginClicked:(UIButton *)sender {
    [self hideKeyboard];
    if (![self checkValidation]){
        return;
    }else{
        
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            SHOW_NETWORK_ERROR_ALERT();
            return;
        } else {
            

            NSString *deviceID = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"] : @"1234";
            
            WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
            inputParam.webserviceRelativePath = @"login.php";
            inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
            inputParam.dictPostParameters = [@{
                                               @"email" : textFielsLoginEmail.text,
                                               @"password" :textFieldLoginPassword.text,
                                               @"device_id":deviceID,
                                               @"device_type": @"ios"
                                               } mutableCopy];
            
            [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
                
                NSLog(@"Login Response==>%@",response);
                
                if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
                    HIDE_LOADING();
                    
                    NSMutableDictionary *dict = [[response valueForKey:@"body"] mutableCopy];
                    [dict setObject:@"1" forKey:@"login_type"];
                                        
                    [USUserInfoModel sharedInstance].email = dict[@"email"];
                    [USUserInfoModel sharedInstance].firstname = dict[@"firstname"];
                    [USUserInfoModel sharedInstance].surname = dict[@"surname"];
                    [USUserInfoModel sharedInstance].profile_pic = dict[@"profile_pic"];
                    [USUserInfoModel sharedInstance].user_id = dict[@"id"];
                    [USUserInfoModel sharedInstance].login_type = @"1"; // 1 for login with info

                    [USUserInfoModel sharedInstance].mobilenumber = dict[@"mobilenumber"]; // Mobile Number
                    [dict setObject:dict[@"mobilenumber"] forKey:@"mobilenumber"];
                    
                    [dict setObject:@"" forKey:@"user_city"];
                    [dict setObject:@"" forKey:@"user_event_type"];
                    //[dict setObject:@"" forKey:@"mobilenumber"];
                    [USUserInfoModel sharedInstance].user_phone_number = @"";
                    [USUserInfoModel sharedInstance].user_event_type = @"";
                    [USUserInfoModel sharedInstance].user_city = @"";
                    
                    NSString *MobStr = [NSString stringWithFormat:@"%@",dict[@"mobilenumber"]];
                    
                    if(MobStr.length==0 || [MobStr isKindOfClass:[NSNull class]] || [MobStr isEqualToString:@""]||[MobStr isEqualToString:@"(null)"]||MobStr==nil || [MobStr isEqualToString:@"<null>"]){
                        
                        APPDELEGATE.signUP = true;
                        
                    }else{
                        APPDELEGATE.signUP = false;
                    }
                    
                    NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
                    
                    for (NSString * key in [dict allKeys])
                    {
                        if (![[dict objectForKey:key] isKindOfClass:[NSNull class]])
                            [prunedDictionary setObject:[dict objectForKey:key] forKey:key];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:prunedDictionary forKey:@"UserInfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self performSegueWithIdentifier:@"CBCityListViewController" sender:nil];

                    });
                    
                } else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIAlertController showAlertWithTitle:@"Wrong Credentials" message:@"Please enter correct email address or password and try again" onViewController:self];
                    });
                }
                
            } error:^(id response, NSError *error) {
                NSLog(@"%@",error.userInfo);
            }];
        }
    }
}

- (IBAction)buttonRegisterClicked:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"CBSignupViewController" sender:nil];
    
}

- (IBAction)actionForgetPassword:(UIButton *)sender {
    
    [self forgotPasswordPopUp];
    
}

-(void)forgotPasswordPopUp{
    
    
    [viewPromoCode removeFromSuperview];
    viewPromoCode=[[UIView alloc] init];
    viewPromoCode.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    viewPromoCode.backgroundColor=[UIColor colorWithRed:(0.0/225.0) green:(0.0/225.0) blue:(0.0/225.0) alpha:0.3];
    viewPromoCode.userInteractionEnabled=TRUE;
    [self.view addSubview:viewPromoCode];
    
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame=CGRectMake(30, (self.view.frame.size.height-160)/2.0, self.view.frame.size.width-60, 160);
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.userInteractionEnabled=YES;
    [viewPromoCode addSubview:contentView];
    
    //       [UIColor colorWithRed:0.91 green:0.38 blue:0.15 alpha:1.0];
    
    UILabel *lblTitle=[[UILabel alloc] init];
    lblTitle.frame=CGRectMake(0, 0, self.view.frame.size.width-60, 45);
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor = [UIColor colorWithRed:0.09 green:0.31 blue:0.50 alpha:1.0];
    lblTitle.text=@"Forgot Password";
    lblTitle.userInteractionEnabled=YES;
    lblTitle.textAlignment=NSTextAlignmentCenter;
    [contentView addSubview:lblTitle];
    
    
    UIButton *btnCancel= [UIButton buttonWithType:UIButtonTypeSystem];
    btnCancel.frame = CGRectMake(CGRectGetMaxX(contentView.frame)-15, CGRectGetMinY(contentView.frame)-15 , 30, 30 );
    [btnCancel addTarget:self action:@selector(cancelPopup:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"icon_cross"] forState:UIControlStateNormal];
    [btnCancel setUserInteractionEnabled:YES];
    //    [btnCancel setTitle:@"X" forState:UIControlStateNormal];
    //    [btnCancel  setTitleColor:[UIColor colorWithRed:0.91 green:0.38 blue:0.15 alpha:1.0] forState:UIControlStateNormal];
    
    //    btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    //    btnCancel.backgroundColor = [UIColor whiteColor];
    btnCancel.layer.cornerRadius = 15.0;
    [viewPromoCode addSubview: btnCancel];
    

    
    CGFloat avWidth = self.view.frame.size.width-80;
    UIView *applyView = [[UIView alloc]init];
    applyView.frame=CGRectMake(10, 100, avWidth, 40);
    applyView.backgroundColor = [UIColor whiteColor];
    applyView.userInteractionEnabled=YES;
    applyView.layer.cornerRadius = 5.0;
    applyView.layer.borderWidth = 1.0;
    applyView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    applyView.layer.masksToBounds = YES;
    applyView.clipsToBounds = YES;
    [contentView addSubview:applyView];
    
    
    
    tfPromoCode  = [[UITextField alloc] init];
    tfPromoCode.frame= CGRectMake(0, 0, avWidth-50, 40);
    tfPromoCode.borderStyle = UITextBorderStyleNone;
    tfPromoCode.font = [UIFont systemFontOfSize:14];
    tfPromoCode.textColor = [UIColor  blackColor];
    tfPromoCode.delegate = self;
    tfPromoCode.tag = 1;
    tfPromoCode.placeholder = @"";
    NSAttributedString *strPD = [[NSAttributedString alloc] initWithString:@"Enter your Email Address." attributes:@{ NSForegroundColorAttributeName : [UIColor  lightGrayColor] }];
    UIView *padView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
    tfPromoCode.leftView = padView;
    tfPromoCode.leftViewMode = UITextFieldViewModeAlways;
    tfPromoCode.attributedPlaceholder = strPD;
    tfPromoCode.backgroundColor = [ UIColor clearColor];
    tfPromoCode.autocorrectionType = UITextAutocorrectionTypeNo;
    tfPromoCode.keyboardType = UIKeyboardTypeEmailAddress;
    tfPromoCode.returnKeyType = UIReturnKeyNext;
    tfPromoCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfPromoCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [applyView addSubview:tfPromoCode];
    
    
    
    UIButton *btnApplyCode= [[UIButton alloc]init];
    btnApplyCode.frame = CGRectMake(avWidth-50, 0 , 50, 40 );
        [btnApplyCode addTarget:self action:@selector(actionForgetSave:) forControlEvents:UIControlEventTouchUpInside];
    [btnApplyCode setTitle:@"SEND" forState:UIControlStateNormal];
    [btnApplyCode  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnApplyCode.titleLabel.font = [UIFont systemFontOfSize:15];
    btnApplyCode.backgroundColor = [UIColor colorWithRed:0.09 green:0.31 blue:0.50 alpha:1.0];
    btnApplyCode.layer.masksToBounds = YES;
    btnApplyCode.clipsToBounds = YES;
    [applyView addSubview: btnApplyCode];
    
}

-(void)cancelPopup:(UIButton *)sender{
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [viewPromoCode removeFromSuperview];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if(result ==MFMailComposeResultCancelled)
    {
        [STMethod showAlert:self Title:@"Alert!" Message:@"Mail cancelled by you" ButtonTitle:@"Ok"];
        return;
    }
    else if(result ==MFMailComposeResultSent)
    {
        [STMethod showAlert:self Title:@"Alert!" Message:@"Our team person will contact you." ButtonTitle:@"Ok"];
        return;
    }
    else if(result ==MFMailComposeResultFailed)
    {
        [STMethod showAlert:self Title:@"Alert!" Message:@"Mail sent failed, Please try again later." ButtonTitle:@"Ok"];
        return;
    }
}


- (IBAction)actionHelpCenter:(UIButton *)sender {
    
    NSString *mailAddress = @"info@citybudng.com";
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        SHOW_NETWORK_ERROR_ALERT();
        return;
    }else{
        
        MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        
        // Configure the fields of the interface.
        [composeVC setToRecipients:@[mailAddress]];
        [composeVC setSubject:@"Contact US"];
        [composeVC setMessageBody:@"Hello CityBud Team," isHTML:NO];
        
        if (![MFMailComposeViewController canSendMail]) {
            NSLog(@"Mail services are not available.");
            return;
        }
        else
        {
            // Present the view controller modally.
            [self presentViewController:composeVC animated:YES completion:nil];
        }
    }
}

- (IBAction)actionForgetSave:(UIButton *)sender {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ([tfPromoCode.text length]== 0){
        [UIAlertController showAlertWithTitle:@"Email" message:@"Please enter your email id." onViewController:self];
        [tfPromoCode becomeFirstResponder];
        return;
        
    }else if (![emailTest evaluateWithObject:tfPromoCode.text]){
        [UIAlertController showAlertWithTitle:@"Email" message:@"Please enter valid email id." onViewController:self];
        [textFieldFoegetEmail becomeFirstResponder];
        return;
    }
    
    [self callForgetPassword:tfPromoCode.text];
    
}

- (void)callForgetPassword:(NSString *)forgetEmail{

    [self hideKeyboard];
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"forget_password.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.dictPostParameters = [@{
                                       @"email" : forgetEmail,
                                       } mutableCopy];
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"forget password Response==>%@",response);
        
        if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
            HIDE_LOADING();
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController showAlertWithTitle:appNAME message:@"New password has been sent to your registered email address." onViewController:self];
                [viewPromoCode removeFromSuperview];
                textFieldFoegetEmail.text = nil;
                [self hideKeyboard];
                
            });
            
        } else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController showAlertWithTitle:appNAME message:[response[@"status"] valueForKeyPath:@"message"] onViewController:self];
            });
        }
        
    } error:^(id response, NSError *error) {
        NSLog(@"%@",error.userInfo);
//        [UIAlertController showAlertWithTitle:appNAME message:@"Something went wrong." onViewController:self];
    }];

    
}

- (IBAction)actionFBLogin:(UIButton *)sender {
    
    if (IS_NETWORK_AVAILABLE()) {
        SHOW_NETWORK_ERROR_ALERT();
        return;
    }
    else
    {

        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
        [login logInWithReadPermissions: @[@"public_profile", @"email"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
        {
                                    if (error)
                                    {
                                        NSLog(@"Process error");
                                    }
                                    else if (result.isCancelled)
                                    {
                                        NSLog(@"Cancelled");
                                    }
                                    else
                                    {
                                        NSLog(@"Logged in");
                                        
                                        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
                                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday,location"}]
//                                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday,location ,friends ,hometown , friendlists"}]
                                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                             if (!error)
                                             {
                                                 NSLog(@"resultis:%@",result);
                                                 
//                                                 first_name
//                                                 last_name
//                                                 email
//                                                 device_type
//                                                 device_id
                                                 
                                                  NSString *deviceID = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"] : @"1234";
                                                 
                                                 NSString *email=[result valueForKey:@"email"] ? [result valueForKey:@"email"] : @"";
                                                 
                                                 NSString *FirstNM=[result valueForKey:@"first_name"] ? [result valueForKey:@"first_name"] : @"";
                                                 
                                                 NSString *LastNM=[result valueForKey:@"last_name"] ? [result valueForKey:@"last_name"] : @"";

                                                 NSDictionary*DataDic=@{@"social_id":[NSString stringWithFormat:@"%@",[result valueForKey:@"id"]],@"device_type":@"ios",@"first_name":FirstNM,@"email":email,@"last_name":LastNM,@"device_id":deviceID};
                                                 
                                                 [self callSocialLogin:DataDic];
                                                 
                                             }
                                             else
                                             {
                                                 NSLog(@"Errorrrrrrrrr %@",error);
                                             }
                                         }];
                                    }
                                }];
    }
}

- (IBAction)actionTwLogin:(UIButton *)sender
{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session)
        {
            NSLog(@"signed in as %@", [session userName]);
        
            NSString *deviceID = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"] : @"1234";
            
            NSString *userName=[session userName] ? [session userName] : @"";
            
            NSArray *NamesArray=[userName componentsSeparatedByString:@" "];
            
            NSString *FirstNM=@"";
            NSString *LastNM=@"";
            
            if (NamesArray.count>0)
            {
                if (NamesArray.count==2)
                {
                   FirstNM=[NamesArray objectAtIndex:0] ? [NamesArray objectAtIndex:0] : @"";
                   LastNM=[NamesArray objectAtIndex:1] ? [NamesArray objectAtIndex:1] : @"";
                }
                else
                {
                    FirstNM=[NamesArray objectAtIndex:0] ? [NamesArray objectAtIndex:0] : @"";
                }
            }
         
            NSString *email=@"";

            NSDictionary*DataDic=@{@"social_id":[NSString stringWithFormat:@"%@",[session userID]],@"device_type":@"ios",@"first_name":FirstNM,@"email":email,@"last_name":LastNM,@"device_id":deviceID};

            [self callSocialLogin:DataDic];
            
        } else
        {
            NSLog(@"errrrrrrrror: %@", [error localizedDescription]);
        }
    }];
    
}


- (void)callSocialLogin:(NSDictionary *)DataDic
{
    
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"social_login.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.dictPostParameters = DataDic.mutableCopy;
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"Social Login Response==>%@",response);
        
        if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
            HIDE_LOADING();
            
//            /**/
            NSMutableDictionary *dict = [[response valueForKey:@"body"] mutableCopy];
            
            [dict setObject:@"2" forKey:@"login_type"];
           
            [USUserInfoModel sharedInstance].email = dict[@"email"];
            [USUserInfoModel sharedInstance].firstname = dict[@"firstname"];
            [USUserInfoModel sharedInstance].surname = dict[@"surname"];
            [USUserInfoModel sharedInstance].profile_pic = dict[@"profile_pic"];
            [USUserInfoModel sharedInstance].user_id = dict[@"id"];
            [USUserInfoModel sharedInstance].login_type = @"2"; // Social_login
            
            [USUserInfoModel sharedInstance].mobilenumber = dict[@"mobilenumber"]; // Mobile Number
            [dict setObject:dict[@"mobilenumber"] forKey:@"mobilenumber"];
            
            [dict setObject:@"" forKey:@"user_city"];
            [dict setObject:@"" forKey:@"user_event_type"];
            
            [USUserInfoModel sharedInstance].user_phone_number = @"";
            [USUserInfoModel sharedInstance].user_event_type = @"";
            [USUserInfoModel sharedInstance].user_city = @"";
            
            
            NSString *MobStr = [NSString stringWithFormat:@"%@",dict[@"mobilenumber"]];
            
            if(MobStr.length == 0 || [MobStr isKindOfClass:[NSNull class]] || [MobStr isEqualToString:@""]||[MobStr isEqualToString:@"(null)"]||MobStr==nil || [MobStr isEqualToString:@"<null>"]){
                
                APPDELEGATE.signUP = true;
                
            }else{
                APPDELEGATE.signUP = false;
            }
            
            NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
            
            for (NSString * key in [dict allKeys])
            {
                if (![[dict objectForKey:key] isKindOfClass:[NSNull class]])
                    [prunedDictionary setObject:[dict objectForKey:key] forKey:key];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:prunedDictionary forKey:@"UserInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
       
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self performSegueWithIdentifier:@"CBCityListViewController" sender:nil];

            });

        } else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController showAlertWithTitle:@"Wrong Credentials" message:@"Please enter correct email address or password and try again" onViewController:self];
            });
        }
        
    } error:^(id response, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}

#pragma mark - TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
//    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
//    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
//    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
//    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
//    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
//    CGFloat heightFraction = numerator / denominator;
//    if (heightFraction < 0.0)
//    {
//        heightFraction = 0.0;
//    }
//    else if (heightFraction > 1.0)
//    {
//        heightFraction = 1.0;
//    }
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
//    {
//        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
//    }
//    else
//    {
//        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
//    }
//    CGRect viewFrame = self.view.frame;
//    viewFrame.origin.y -= animatedDistance;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//    [self.view setFrame:viewFrame];
//    [UIView commitAnimations];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
//    CGRect viewFrame = self.view.frame;
//    viewFrame.origin.y += animatedDistance;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//    [self.view setFrame:viewFrame];
//    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return [textField resignFirstResponder];
    return YES;
}

#pragma mark - LocalMethods
//TODO: hide keyboard
-(void)hideKeyboard{
    
    [self.view endEditing:YES];
}

//TODO: Check Validation
- (BOOL)checkValidation {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    // must contain digit, spcl char, digit, lower and upper case, min 6 length
    //NSString *pwdRegex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}";
    //NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    
    
    if ([textFielsLoginEmail.text length]== 0){
        [UIAlertController showAlertWithTitle:@"Email" message:@"Please enter your email id." onViewController:self];
        return NO;
    }else if (![emailTest evaluateWithObject:textFielsLoginEmail.text]){
        [UIAlertController showAlertWithTitle:@"Email" message:@"Please enter valid email id." onViewController:self];
        return NO;
    }else if ([textFieldLoginPassword.text length] <= 5){
        [UIAlertController showAlertWithTitle:@"Password" message:@"Please enter valid password with 6 character long." onViewController:self];
        return NO;
    }/*else if (![pwdTest evaluateWithObject:textFieldLoginPassword.text]){
        [UIAlertController showAlertWithTitle:@"Error" message:@"Please enter valid password." onViewController:self];
        return NO;
    }*/
    
    return YES;
}
@end
