//
//  CBChangeEmailVC.m
//  CityBud
//
//  Created by Mohit Garg on 01/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBChangeEmailVC.h"

@interface CBChangeEmailVC (){
    CGFloat animatedDistance;
}

@end

@implementation CBChangeEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSDictionary *dictUserDefault = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    tfOldEmail.text = dictUserDefault[@"email"];
    tfOldEmail.userInteractionEnabled = NO;
    
//    tfOldEmail.text = [USUserInfoModel sharedInstance].email;
//
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrivateMethod

- (void)hideKeyboard{
    [self.view endEditing:YES];
}

- (BOOL)checkValidation {
    
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //
    // must contain digit, spcl char, digit, lower and upper case, min 6 length
    //    NSString *pwdRegex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}";
    //    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    //    (![pwdTest evaluateWithObject:tfSignupConfirmPassword.text])
    
    
    if ([tfOldEmail.text length]== 0 ) {
        [UIAlertController showAlertWithTitle:appNAME message:@"Could not get your Old Email, please try again." onViewController:self];
        tfOldEmail.text = nil;
        [tfOldEmail becomeFirstResponder];
        return NO;
    }else if (![emailTest evaluateWithObject:tfOldEmail.text]) {
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter valid old email address." onViewController:self];
        tfOldEmail.text = nil;
        [tfOldEmail becomeFirstResponder];
        return NO;
    }else if ([tfNewEmail.text length]== 0 ){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter your new email address." onViewController:self];
        [tfNewEmail becomeFirstResponder];
        return NO;
    }else if (![emailTest evaluateWithObject:tfNewEmail.text]) {
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter valid new email address." onViewController:self];
        [tfNewEmail becomeFirstResponder];
        return NO;
    }else if ([tfConfirmEmail.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter your confirm email address." onViewController:self];
        tfConfirmEmail.text = nil;
        [tfConfirmEmail becomeFirstResponder];
        return NO;
    }else if (![emailTest evaluateWithObject:tfConfirmEmail.text]) {
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter valid confirm email address." onViewController:self];
        
        [tfConfirmEmail becomeFirstResponder];
        return NO;
    }else if (![tfNewEmail.text isEqualToString:tfConfirmEmail.text]) {
        [UIAlertController showAlertWithTitle:appNAME message:@"Email doesn't match." onViewController:self];
        
        [tfConfirmEmail becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)callChangeEmailWebservice{
    /* http://socialbud.imvisile.com/api/users/changeemail.php
    
    user_email
    user_id
    */
    
    NSString *userID;
    NSDictionary *dictUserDefault = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"];
    userID = dictUserDefault[@"id"];
    
    [self hideKeyboard];
    
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"changeemail.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.dictPostParameters = [@{
                                       @"user_email" : tfConfirmEmail.text,
                                       @"user_id" :userID
                                       } mutableCopy];
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"update email Response==>%@",response);
        
        if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
            HIDE_LOADING();
            
            NSDictionary *dict = [response valueForKey:@"body"][0];
            
            [USUserInfoModel sharedInstance].email = dict[@"email"];

            
            NSMutableDictionary *dictUserDefault = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"] mutableCopy];
            
            [dictUserDefault removeObjectForKey:@"email"];
            [dictUserDefault setObject:dict[@"email"] forKey:@"email"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController showAlertWithTitle:appNAME message:@"Email changed successfully." onViewController:self];
                [[NSUserDefaults standardUserDefaults] setObject:dictUserDefault forKey:@"UserInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                tfOldEmail.text = dict[@"email"];
                tfNewEmail.text = nil;
                tfConfirmEmail.text = nil;
                
                [self.navigationController popViewControllerAnimated:YES];
                
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

- (IBAction)actionChangeEmail:(UIButton *)sender {
    if (![self checkValidation]){
        return;
    }else{
        if ([AFNetworkReachabilityManager sharedManager].reachable){
            SHOW_NETWORK_ERROR_ALERT();
            return;
        }else{
            // implement change email id api here
            [self callChangeEmailWebservice];
        }
    }
}


@end
