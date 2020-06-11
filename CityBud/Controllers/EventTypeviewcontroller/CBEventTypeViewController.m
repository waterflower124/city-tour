//
//  CBEventTypeViewController.m
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBEventTypeViewController.h"
#import "CBMenuViewController.h"

@interface CBEventTypeViewController ()
{
    CGFloat animatedDistance;
    NSString *selectedEventType;
}
@end

@implementation CBEventTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];

    constraintDDHeight.constant = 0;
    viewDropDown.hidden = YES;
    
    if (APPDELEGATE.signUP == true)
    {
        textFieldPhoneNumber.hidden = false;
        phonenumberlabel.hidden = false;
    }
    else
    {
        textFieldPhoneNumber.hidden = true;
        phonenumberlabel.hidden = true;
    }
    
}


-(void)viewDidAppear:(BOOL)animated {
    
    constraintDDHeight.constant = 0;
    viewDropDown.hidden = YES;
   

    
}
    
-(void)hideKeyboard{
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TextField Delegates
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    
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
//    
////    [self addToolBar:textField];
//}
//
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    
//    
//    CGRect viewFrame = self.view.frame;
//    viewFrame.origin.y += animatedDistance;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//    [self.view setFrame:viewFrame];
//    [UIView commitAnimations];
//}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self.view endEditing:YES];
//    return [textField resignFirstResponder];
//    return YES;
//}
//
//
///* Done Cancel Tool Bar*/
//
//-(void) addToolBar : (UITextField *) _textField {
//    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.layer.frame.size.width, 40)];
//    keyboardToolBar.barStyle = UIBarStyleDefault;
//    
//    keyboardToolBar.backgroundColor=[UIColor lightGrayColor];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [UIColor colorWithRed:0.16 green:0.38 blue:0.56 alpha:1.0],NSForegroundColorAttributeName,
//                                nil];
//    
//    [keyboardToolBar setItems: [NSArray arrayWithObjects:
//                                [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
//                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
//                                nil]];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes
//                                                forState:UIControlStateNormal];
//    
//    _textField.inputAccessoryView = keyboardToolBar;
//}
//
//
//
//
//-(void)cancelNumberPad{
//    if ([textFieldPhoneNumber isEditing]==YES) {
//        
//        textFieldPhoneNumber.text = @"";
//        [self.view endEditing:YES];
//        
//    }
//}
//-(void)doneWithNumberPad{
//    if ([textFieldPhoneNumber isEditing]==YES){
//        
//        [self.view endEditing:YES];
//        //calling next button acrion
//        [self performSelector:@selector(actionSubmit:) withObject:self afterDelay:1.0];
//        
//    }
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == textFieldPhoneNumber) {
        
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
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 15) {
            return NO;
        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"+1234567890"];
        
        if ([string rangeOfCharacterFromSet:set].location == NSNotFound) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Button Actions
    
- (IBAction)actionChooseEvent:(UIButton *)sender {
    
    if (sender.selected == YES) {
        [sender setSelected:NO];
        [self hideDropDown];
    } else {
        [sender setSelected:YES];
        [self showDropDown];
    }
    //buttonChooseEvent.titleLabel.text = selectedEventType;
}
    
- (IBAction)buttonNightLifeClicked:(UIButton *)sender {
    
    [self hideDropDown];
    
    [buttonEducation setSelected:NO];
    [buttonSports setSelected:NO];
    [buttonFestivals setSelected:NO];
    [buttonReligious setSelected:NO];
    
    if (sender.selected == NO) {
        [sender setSelected:YES];
        //buttonChooseEvent.titleLabel.text = sender.titleLabel.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [buttonChooseEvent setTitle:sender.titleLabel.text forState:UIControlStateNormal];
            buttonChooseEvent.selected = NO;
        });
       
        selectedEventType = sender.titleLabel.text;
    } else {
        [sender setSelected:NO];
        selectedEventType = nil;
    }
}

- (IBAction)buttonEducationClicked:(UIButton *)sender {
    
    [self hideDropDown];
    
    [buttonNightLife setSelected:NO];
    [buttonSports setSelected:NO];
    [buttonFestivals setSelected:NO];
    [buttonReligious setSelected:NO];
    
    if (sender.selected == NO) {
        [sender setSelected:YES];
        //buttonChooseEvent.titleLabel.text = sender.titleLabel.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [buttonChooseEvent setTitle:sender.titleLabel.text forState:UIControlStateNormal];
            buttonChooseEvent.selected = NO;
        });
        
        selectedEventType = sender.titleLabel.text;
    } else {
        [sender setSelected:NO];
        selectedEventType = nil;
    }
}

- (IBAction)buttonSportsClicked:(UIButton *)sender {
    
    [self hideDropDown];
    
    [buttonNightLife setSelected:NO];
    [buttonEducation setSelected:NO];
    [buttonFestivals setSelected:NO];
    [buttonReligious setSelected:NO];
    
    if (sender.selected == NO) {
        [sender setSelected:YES];
        //buttonChooseEvent.titleLabel.text = sender.titleLabel.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [buttonChooseEvent setTitle:sender.titleLabel.text forState:UIControlStateNormal];
            buttonChooseEvent.selected = NO;
            
        });
        
        selectedEventType = sender.titleLabel.text;
    } else {
        [sender setSelected:NO];
        selectedEventType = nil;
    }
}

- (IBAction)buttonFestivalsClicked:(UIButton *)sender {
    
    [self hideDropDown];
    
    [buttonNightLife setSelected:NO];
    [buttonEducation setSelected:NO];
    [buttonSports setSelected:NO];
    [buttonReligious setSelected:NO];
    
    if (sender.selected == NO) {
        [sender setSelected:YES];
        //buttonChooseEvent.titleLabel.text = sender.titleLabel.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [buttonChooseEvent setTitle:sender.titleLabel.text forState:UIControlStateNormal];
            buttonChooseEvent.selected = NO;
        });
        
        selectedEventType = sender.titleLabel.text;
    } else {
        [sender setSelected:NO];
        selectedEventType = nil;
    }
}

- (IBAction)buttonReligiousClicked:(UIButton *)sender {
    
    [self hideDropDown];
    
    [buttonNightLife setSelected:NO];
    [buttonEducation setSelected:NO];
    [buttonSports setSelected:NO];
    [buttonFestivals setSelected:NO];
    
    if (sender.selected == NO) {
        [sender setSelected:YES];
        //buttonChooseEvent.titleLabel.text = sender.titleLabel.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            [buttonChooseEvent setTitle:sender.titleLabel.text forState:UIControlStateNormal];
            buttonChooseEvent.selected = NO;
        });
        
        selectedEventType = sender.titleLabel.text;
    } else {
        [sender setSelected:NO];
        selectedEventType = nil;
    }
}

#pragma mark - Drop Down hide Show method

- (void)hideDropDown{
    
    [UIView transitionWithView:viewDropDown
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        constraintDDHeight.constant = 0;
                        viewDropDown.hidden = YES;
                    }
                    completion:NULL];
    
//    constraintDDHeight.constant = 0;
//    viewDropDown.hidden = YES;
//    [viewDropDown setHidden:YES];
//    
//    
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.view layoutIfNeeded];
//    }];
    

}

- (void)showDropDown{

    [UIView transitionWithView:viewDropDown
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        constraintDDHeight.constant = 180;
                        viewDropDown.hidden = NO;
                    }
                    completion:NULL];
    
//    constraintDDHeight.constant = 180;
//    viewDropDown.hidden = NO;
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.view layoutIfNeeded];
//    }];
//    

}

#pragma mark - action Submit
- (IBAction)actionSubmit:(UIButton *)sender {
    
    [self hideKeyboard];
    
    if (selectedEventType.length == 0) {
        [UIAlertController showAlertWithTitle:appNAME message:@"Please choose your favourite event type." onViewController:self];
        return;
    }
    
    if (APPDELEGATE.signUP == true)
    {
        if (textFieldPhoneNumber.text.length == 0) {
            
            [UIAlertController showAlertWithTitle:appNAME message:@"Please enter phone number." onViewController:self];
            return;
        }
        
        if (textFieldPhoneNumber.text.length <= 9) {
            [UIAlertController showAlertWithTitle:appNAME message:@"Please enter valid phone number minimum of 10 digits." onViewController:self];
            return;
        }
    }
    
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        SHOW_NETWORK_ERROR_ALERT();
        return;
    } else {
        [self callSaveData];
        //[self callAllEvent];
    }
}

- (void)callSaveData{
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"saveinfo.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    
    if (APPDELEGATE.signUP==true)
    {
        inputParam.dictPostParameters = [@{
                                           @"user_id" : [USUserInfoModel sharedInstance].user_id,
                                           @"event_city" : self.cityName,
                                           @"event_name" : selectedEventType,
                                           @"phone_no" : textFieldPhoneNumber.text,
                                           } mutableCopy];
    }
    else
    {
        inputParam.dictPostParameters = [@{
                                           @"user_id" : [USUserInfoModel sharedInstance].user_id,
                                           @"event_city" : self.cityName,
                                           @"event_name" : selectedEventType                                           } mutableCopy];
    }
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"Save Data response==>%@",response);
        
        if([[response valueForKeyPath:@"status.code"] isEqual:@"1"]){
            HIDE_LOADING();
            NSLog(@"User Information saved");
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            
            CBMenuViewController *leftMenu = (CBMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CBMenuViewController"];
            
            MFSideMenuContainerViewController *slideVC = (MFSideMenuContainerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MFSideMenuContainerViewController"];
            
            UITabBarController *tabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"CBTabBarController"];
            
            slideVC = [MFSideMenuContainerViewController
                       containerWithCenterViewController:tabBarVC
                       leftMenuViewController:leftMenu
                       rightMenuViewController:nil];
            slideVC.menuWidth = self.view.frame.size.width-50;
            
            NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"] mutableCopy];
            [dict setObject:self.cityName forKey:@"user_city"];
            [dict setObject:selectedEventType forKey:@"user_event_type"];
            
            if (APPDELEGATE.signUP == true)
            {
                [dict setObject:textFieldPhoneNumber.text forKey:@"mobilenumber"];
                
                [USUserInfoModel sharedInstance].user_phone_number = textFieldPhoneNumber.text;
                
                APPDELEGATE.signUP = false;
            }
            else
            {
                [USUserInfoModel sharedInstance].user_phone_number = [[NSUserDefaults standardUserDefaults] valueForKey:@"mobilenumber"];
            }
            
            [USUserInfoModel sharedInstance].user_event_type = selectedEventType;
            [USUserInfoModel sharedInstance].user_city = self.cityName;
            
            NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
            
            for (NSString * key in [dict allKeys])
            {
                if (![[dict objectForKey:key] isKindOfClass:[NSNull class]])
                    [prunedDictionary setObject:[dict objectForKey:key] forKey:key];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:prunedDictionary forKey:@"UserInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self presentViewController:slideVC animated:NO completion:^{
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[CBEventTypeViewController class]]) {
                        NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
                        [array removeObject:vc];
                        self.navigationController.viewControllers = array;
                    }
                }
            }];
          }
    } error:^(id response, NSError *error) {
        NSLog(@"%@",error.userInfo);
        NSLog(@"Soemthing went wrong");
    }];
    

}

- (void)callAllEvent{
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"all_event.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.dictPostParameters = [@{
                                       @"event_city" : self.cityName,
                                       @"category" :@""
                                       } mutableCopy];
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"All events response==>%@",response);
        
        if([[response valueForKeyPath:@"status.code"] isEqual:@"1"]){
            HIDE_LOADING();
            
            NSArray *array = [response valueForKey:@"body"];
            
            if (array.count) {
                [USUserInfoModel sharedInstance].arrayEvents = array;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    
                    CBMenuViewController *leftMenu = (CBMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CBMenuViewController"];
                    
                    MFSideMenuContainerViewController *slideVC = (MFSideMenuContainerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MFSideMenuContainerViewController"];
                    
                    UITabBarController *tabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"CBTabBarController"];
                    
                    slideVC = [MFSideMenuContainerViewController
                               containerWithCenterViewController:tabBarVC
                               leftMenuViewController:leftMenu
                               rightMenuViewController:nil];
                    slideVC.menuWidth = self.view.frame.size.width-50;
                    
                    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"] mutableCopy];
                    [dict setObject:self.cityName forKey:@"user_city"];
                    [dict setObject:selectedEventType forKey:@"user_event_type"];
                    [dict setObject:textFieldPhoneNumber.text forKey:@"mobilenumber"];
                    [USUserInfoModel sharedInstance].user_phone_number = textFieldPhoneNumber.text;
                    [USUserInfoModel sharedInstance].user_event_type = selectedEventType;
                    [USUserInfoModel sharedInstance].user_city = self.cityName;
                    
                    NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
                    
                    for (NSString * key in [dict allKeys])
                    {
                        if (![[dict objectForKey:key] isKindOfClass:[NSNull class]])
                            [prunedDictionary setObject:[dict objectForKey:key] forKey:key];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:prunedDictionary forKey:@"UserInfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    [self presentViewController:slideVC animated:NO completion:^{
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[CBEventTypeViewController class]]) {
                                NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
                                [array removeObject:vc];
                                self.navigationController.viewControllers = array;
                            }
                        }
                    }];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIAlertController alertControllerWithTitle:@"No Events!" message:@"Sorry, We don't have any event right now for this city, please choose another city" buttonTitle:@"OK" viewController:self alertAction:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                });
                
            }
            
        } else if ([[response valueForKeyPath:@"status.code"] isEqual:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController showAlertWithTitle:@"No Events Founds" message:@"" onViewController:self];
            });
        }
        
    } error:^(id response, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];

}


@end
