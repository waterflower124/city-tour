//
//  CBChangePasswordVC.m
//  CityBud
//
//  Created by Mohit Garg on 01/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBChangePasswordVC.h"
#import "NSString+MD5.h"

@interface CBChangePasswordVC (){
    CGFloat animatedDistance;
    NSString *currentPassword;
    NSString *userID;
}

@end

@implementation CBChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    NSDictionary *dictUserDefault = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"];

    currentPassword = [dictUserDefault[@"password"] lowercaseString];
    userID = dictUserDefault[@"id"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrivateMethods

-(void)hideKeyboard{
    
    [self.view endEditing:YES];
}

- (BOOL)checkValidation {
    
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    
    // must contain digit, spcl char, digit, lower and upper case, min 6 length
//    NSString *pwdRegex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}";
//    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
//    (![pwdTest evaluateWithObject:tfSignupConfirmPassword.text])
    
    //md5 password
    NSString *hashOldPassword = [[[NSString alloc] generateMD5:tfOldPassword.text] lowercaseString];

    
    
    if ([tfOldPassword.text length]== 0 ) {
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter your old password." onViewController:self];
        tfOldPassword.text = nil;
        [tfOldPassword becomeFirstResponder];
        return NO;
    }
//    else if ([tfOldPassword.text length] <= 5 ) {
//        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter valid old password with 6 character long." onViewController:self];
//        tfOldPassword.text = nil;
//        [tfOldPassword becomeFirstResponder];
//        return NO;
//    }
    else if (![hashOldPassword isEqualToString:currentPassword]) {
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter correct old password." onViewController:self];
        tfOldPassword.text = nil;
        [tfOldPassword becomeFirstResponder];
        return NO;
    }else if ([tfNewPassword.text length]== 0 ){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter your new password." onViewController:self];
        tfNewPassword.text = nil;
        [tfNewPassword becomeFirstResponder];
        return NO;
    }else if ([tfNewPassword.text length] <= 5 ) {
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter valid password with 6 character long." onViewController:self];
        tfNewPassword.text = nil;
        [tfNewPassword becomeFirstResponder];
        return NO;
    }else if ([tfConfirmPassword.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter your confirm password." onViewController:self];
        tfConfirmPassword.text = nil;
        [tfConfirmPassword becomeFirstResponder];
        return NO;
    }else if (tfNewPassword.text != tfConfirmPassword.text){
        [UIAlertController showAlertWithTitle:appNAME message:@"Password doesn't match." onViewController:self];
        tfConfirmPassword.text = nil;
        [tfConfirmPassword becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    //    [self addToolBar:textField];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return [textField resignFirstResponder];
    return YES;
}

#pragma mark - Button Actions
- (IBAction)actionBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionChangePassword:(UIButton *)sender {
    
    if (![self checkValidation]){
        return;
    }else{
        if ([AFNetworkReachabilityManager sharedManager].reachable){
            SHOW_NETWORK_ERROR_ALERT();
            return;
        }else{
            //Implement web service here.
            [self callChangePasswordWebservice];
            
        }
    }
    
}

- (void)callChangePasswordWebservice{

    NSString *hashNewPassword = [[NSString alloc] generateMD5:tfConfirmPassword.text];
    [self hideKeyboard];

    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"changepassword.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.dictPostParameters = [@{
                                       @"user_id" : userID,
                                       @"user_password" :hashNewPassword
                                       } mutableCopy];
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"Change Password Response==>%@",response);
        
        if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
            HIDE_LOADING();
            
            NSDictionary *dict = [response valueForKey:@"body"][0];

            NSMutableDictionary *dictUserDefault = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"] mutableCopy];
            
            [dictUserDefault removeObjectForKey:@"password"];
            [dictUserDefault setObject:dict[@"password"] forKey:@"password"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dictUserDefault forKey:@"UserInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController showAlertWithTitle:appNAME message:@"Password changed successfully." onViewController:self];
                
                tfOldPassword.text = nil;
                tfNewPassword.text = nil;
                tfConfirmPassword.text = nil;
 
            });
            
        } else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController showAlertWithTitle:appNAME message:[response[@"status"] valueForKeyPath:@"message"] onViewController:self];
            });
        }
        
    } error:^(id response, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}

@end
