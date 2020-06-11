//
//  CBSignupViewController.m
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBSignupViewController.h"
#import "CBCityListViewController.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
//#import <TwitterKit/TwitterKit.h>
#import <Twitter/Twitter.h>
#import <TwitterKit/TWTRKit.h>

@interface CBSignupViewController (){
    CGFloat animatedDistance;
}

@end

@implementation CBSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //hide key board on tap using tapgesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == tfSignupFirstName || textField == tfSignupLastName) {
        
        // do not allow the first character to be space | do not allow more than one space
        if ([string isEqualToString:@" "]) {
            if (!textField.text.length)
                return NO;
            if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
                return NO;
        }
        
        // allow backspace
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length < textField.text.length) {
            return YES;
        }
        
        // in case you need to limit the max number of characters
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 30) {
            return NO;
        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 "];
        
        if ([string rangeOfCharacterFromSet:set].location == NSNotFound) {
            return NO;
        }
    
    }
    return YES;
}


#pragma mark - Button Action
- (IBAction)actionCreateAccount:(UIButton *)sender {
    
//    [self performSegueWithIdentifier:@"CBCityListViewController" sender:nil];
//    return;
    
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
            inputParam.webserviceRelativePath = @"register.php";
            inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
            inputParam.dictPostParameters = [@{
                                               @"first_name" : tfSignupFirstName.text,
                                               @"last_name" : tfSignupLastName.text,
                                               @"email" : tfSignupEmailAddress.text,
                                               @"password" :tfSignupPassword.text,
                                               @"device_id":deviceID,
                                               @"device_type": @"ios"
                                               } mutableCopy];
            
            [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
                
                NSLog(@"response==>%@",response);
                
                if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
                    HIDE_LOADING();
                 
                    NSMutableDictionary *dict = [[response valueForKey:@"body"] mutableCopy];
                    
                    [dict setObject:@"1" forKey:@"login_type"];
                 
                    [USUserInfoModel sharedInstance].user_id = dict[@"id"];
                    [USUserInfoModel sharedInstance].firstname = dict[@"firstname"];
                    [USUserInfoModel sharedInstance].surname = dict[@"surname"];
                    [USUserInfoModel sharedInstance].email = dict[@"email"];
                    [USUserInfoModel sharedInstance].profile_pic = dict[@"profile_pic"];
                    [USUserInfoModel sharedInstance].login_type = @"1";
                    
                    [dict setObject:@"" forKey:@"user_city"];
                    [dict setObject:@"" forKey:@"user_event_type"];
                    
                    
                    
                    [dict setObject: @"" forKey:@"question1"];
                    [dict setObject:@"" forKey:@"question2"];
                    [dict setObject:@"" forKey:@"social_id"];
                    [dict setObject:@"" forKey:@"student_no"];
                    [dict setObject:@"" forKey:@"type"];
                    [dict setObject:@"" forKey:@"validation_code"];
                    
                    [USUserInfoModel sharedInstance].user_phone_number = @"";
                    [USUserInfoModel sharedInstance].user_event_type = @"";
                    [USUserInfoModel sharedInstance].user_city = @"";
                    
                    
                    NSString *MobStr = [NSString stringWithFormat:@"%@",dict[@"mobilenumber"]];
                    
                    if(MobStr.length==0 || [MobStr isKindOfClass:[NSNull class]] || [MobStr isEqualToString:@""]||[MobStr isEqualToString:@"(null)"]||MobStr==nil || [MobStr isEqualToString:@"<null>"]){
                        [dict setObject:@"" forKey:@"mobilenumber"];
                        APPDELEGATE.signUP = true;
                        
                    }else{
                        
                        [dict setObject:dict[@"mobilenumber"] forKey:@"mobilenumber"];
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
                        [UIAlertController showAlertWithTitle:appNAME message:[NSString stringWithFormat:@"%@",[response[@"status"] valueForKeyPath:@"message"]] onViewController:self];
                    });
                }
                
            } error:^(id response, NSError *error) {
                NSLog(@"%@",error.userInfo);
            }];
        }
    }
}

- (IBAction)actionAlreadyMember:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionFbSignup:(UIButton *)sender
{
    if (IS_NETWORK_AVAILABLE())
    {
        SHOW_NETWORK_ERROR_ALERT();
        
        return;
    }
    else
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    //                                    self.view.userInteractionEnabled = NO;
                                    if (error) {
                                        NSLog(@"Process error");
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    } else {
                                        NSLog(@"Logged in");
                                        
                                        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
                                        
                                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday,location ,friends ,hometown , friendlists"}]
                                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                             if (!error)
                                             {
                                                 NSLog(@"resultis:%@",result);
                                                 [self callSocialLogin:[result valueForKey:@"id"]];
                                                 
                                                 
                                             }
                                             else
                                             {
                                                 NSLog(@"Error %@",error);
                                             }
                                         }];
                                    }
                                }];
    }    
}


- (void)callSocialLogin:(NSString *)socialID{
    
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"social_login.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.dictPostParameters = [@{ @"social_id" : socialID } mutableCopy];
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"Social Login Response==>%@",response);
        
        if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
            HIDE_LOADING();
            
            //            /**/
            NSMutableDictionary *dict = [[response valueForKey:@"body"] mutableCopy];
            [dict setObject:@"2" forKey:@"login_type"];
            //
            //            //                     email;
            //            //                     firstname;
            //            //                     surname;
            //            //                     profile_pic;
            //            //                     user_id;
            //            //                     user_event_type;
            //            //                     user_phone_number;
            //            //                     user_city;
            //            //                     arrayEvents;
            //
            [USUserInfoModel sharedInstance].email = dict[@"email"];
            [USUserInfoModel sharedInstance].firstname = dict[@"firstname"];
            [USUserInfoModel sharedInstance].surname = dict[@"surname"];
            [USUserInfoModel sharedInstance].profile_pic = dict[@"profile_pic"];
            [USUserInfoModel sharedInstance].user_id = dict[@"id"];
            [USUserInfoModel sharedInstance].login_type = @"2";
            
            [USUserInfoModel sharedInstance].mobilenumber = dict[@"mobilenumber"]; // Mobile Number
            [dict setObject:dict[@"mobilenumber"] forKey:@"mobilenumber"];
            
            [dict setObject:@"" forKey:@"user_city"];
            [dict setObject:@"" forKey:@"user_event_type"];
            
            [USUserInfoModel sharedInstance].user_phone_number = @"";
            [USUserInfoModel sharedInstance].user_event_type = @"";
            [USUserInfoModel sharedInstance].user_city = @"";
            
            //NSString *MobStr = dict[@"mobilenumber"];
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

- (IBAction)actionTwSignup:(UIButton *)sender {
    // Objective-C
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            [self callSocialLogin:[session userID]];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

#pragma mark - PrivateMethods

-(void)hideKeyboard{
    
    [self.view endEditing:YES];
}

- (BOOL)checkValidation {

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    // must contain digit, spcl char, digit, lower and upper case, min 6 length
    //NSString *pwdRegex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}";
    //NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    
    
    
    if ([tfSignupFirstName.text length]== 0) {
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter your first name." onViewController:self];
        return NO;
    }else if ([tfSignupLastName.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter your last name." onViewController:self];
        return NO;
    }else if ([tfSignupEmailAddress.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter your email id." onViewController:self];
        return NO;
    }else if (![emailTest evaluateWithObject:tfSignupEmailAddress.text]){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter valid email id." onViewController:self];
        return NO;
    }else if ([tfSignupPassword.text length]== 0) {// || (![pwdTest evaluateWithObject:tfSignupPassword.text])){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter password." onViewController:self];
        return NO;
    }else if ([tfSignupPassword.text length] <= 5) { // || (![pwdTest evaluateWithObject:tfSignupConfirmPassword.text])){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter valid password with 6 character long." onViewController:self];
        return NO;
    }else if ([tfSignupConfirmPassword.text length]== 0) {// || (![pwdTest evaluateWithObject:tfSignupPassword.text])){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter confirm password." onViewController:self];
        return NO;
    }
    
    if ([tfSignupPassword.text isEqualToString:tfSignupConfirmPassword.text]){
       
    }
    else
    {
        [UIAlertController showAlertWithTitle:appNAME message:@"Password doesn't match." onViewController:self];
        return NO;
    }
    return YES;
}

@end
