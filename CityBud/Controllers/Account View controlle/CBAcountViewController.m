//
//  CBAcountViewController.m
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBAcountViewController.h"
#import "CBLoginViewController.h"
#import "CBSearchResultViewController.h"
#import "CBTermsAndConditionsViewController.h"
#import "STMethod.h"
#import "AppDelegate.h"

@interface CBAcountViewController (){

    NSArray *arrResponse;
    AppDelegate *appdel;
}

@end

@implementation CBAcountViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    //Disable change email/pwd for social user.
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    
    if ([dict[@"login_type"] isEqualToString:@"2"]){
        
        [buttonChangePassword setEnabled:FALSE];
        [buttonChangePassword setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        
        [buttonChangeEmail setEnabled:FALSE];
        [buttonChangeEmail setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonMenuClicked:(UIButton *)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

- (IBAction)actionChangePassword:(UIButton *)sender {
    [self performSegueWithIdentifier:@"CBChangePasswordVC" sender:nil];
}

- (IBAction)actionChangeEmail:(UIButton *)sender {
    [self performSegueWithIdentifier:@"CBChangeEmailVC" sender:nil];
}

- (IBAction)actionYourEvents:(UIButton *)sender {
    // Implementation your event api
    /* 
     http://socialbud.imvisile.com/api/users/user_event.php
     user_id
    */
    
    [self performSegueWithIdentifier:@"CBSearchResultViewController" sender:nil];
    
}

- (IBAction)actionTnC:(UIButton *)sender {
    _isPrivacy = NO; 
    appdel.ValueStr =@"Terms";
    [self performSegueWithIdentifier:@"CBTearmsConditions" sender:nil];
}

- (IBAction)actionPrivacy:(UIButton *)sender {
    _isPrivacy = YES;
    appdel.ValueStr =@"Privacy";
    [self performSegueWithIdentifier:@"CBTearmsConditions" sender:nil];
}

- (IBAction)actionContactUS:(UIButton *)sender {
   
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

- (IBAction)actionLogout:(UIButton *)sender {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        SHOW_NETWORK_ERROR_ALERT();
        return;
    }else{
        // call logout api
        
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            SHOW_NETWORK_ERROR_ALERT();
            return;
        } else {
            
            NSDictionary *dictUserDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
            NSString *userID = dictUserDefault[@"id"];
            
            WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
            inputParam.webserviceRelativePath = @"logout.php";
            inputParam.shouldShowLoadingActivity = YES;
            inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
            inputParam.dictPostParameters = [@{
                                               @"user_id" : userID
                                               } mutableCopy];
            
            [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
                
                NSLog(@"Log Out Response==>%@",response);
                
                if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
                    HIDE_LOADING();
                    
//                    NSDictionary *dict = [response valueForKey:@"body"];

                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //                     email;
                        //                     firstname;
                        //                     surname;
                        //                     profile_pic;
                        //                     user_id;
                        //                     user_event_type;
                        //                     user_phone_number;
                        //                     user_city;
                        //                     arrayEvents;
                        
                        [USUserInfoModel sharedInstance].email = nil;
                        [USUserInfoModel sharedInstance].firstname = nil;
                        [USUserInfoModel sharedInstance].surname = nil;
                        [USUserInfoModel sharedInstance].profile_pic = nil;
                        [USUserInfoModel sharedInstance].user_id = nil;
                        [USUserInfoModel sharedInstance].user_event_type = nil;
                        [USUserInfoModel sharedInstance].user_phone_number = nil;
                        [USUserInfoModel sharedInstance].user_city = nil;
                        [USUserInfoModel sharedInstance].arrayEvents = nil;
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [UIAlertController showAlertWithTitle:appNAME message:[response[@"status"] valueForKeyPath:@"message"] onViewController:self];
                        
                        
                        if (APPDELEGATE.signUP == true)
                        {
                            APPDELEGATE.signUP = false;
                        }
                        
                        // drag user back to login screen
                        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        CBLoginViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"CBLoginViewController"];
                        
//                        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
//                            [self.navigationController popToViewController:add animated:YES];
//                        }];

                        
                        
                        

//                            self.view.window.rootViewController =[storyboard instantiateViewControllerWithIdentifier:@"CBLoginViewController"];

                        
                        
                        
                        
                        
                        [self dismissViewControllerAnimated:NO completion:^{
                           // [self.navigationController popViewControllerAnimated:YES];
                            
                            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                            
                            CBLoginViewController *cVC = (CBLoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CBLoginViewController"];
                            
                            UINavigationController *hNVC = [USUserInfoModel sharedInstance].navVC;
                            
                            [hNVC setViewControllers:[NSArray arrayWithObjects:cVC, nil] animated:YES];
                            
                            NSLog(@"sdfs");
                            

                        }];
                        
                        
//                        CBLoginViewController *add =
//                        [storyboard instantiateViewControllerWithIdentifier:@"CBLoginViewController"];
                       // [self.navigationController setHidesBottomBarWhenPushed:YES];
                       // [self.navigationController presentViewController:add animated:YES completion:nil];
                        
                       // [self presentViewController:add animated:YES completion:nil];
                        
                    });
                    
                } else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIAlertController showAlertWithTitle:appNAME message:[response[@"status"] valueForKeyPath:@"message"] onViewController:self];
                    });
                }
                
            } error:^(id response, NSError *error) {
//                [UIAlertController showAlertWithTitle:appNAME message:@"Something went wrong..!!" onViewController:self];
                NSLog(@"%@",error.userInfo);
            }];
        }
        
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CBSearchResultViewController"]){
        
        CBSearchResultViewController *searchResultVC = segue.destinationViewController;
        //        searchResultVC.arrSearchResult = [arrResponse mutableCopy];
        searchResultVC.isFromAccount = YES;
    }else if ([segue.identifier isEqualToString:@"CBTearmsConditions"]){
        CBTermsAndConditionsViewController *tncVC = segue.destinationViewController;
        if(_isPrivacy == YES){
            tncVC.isPrivacy = YES;
        }
        
    }
    
}

- (IBAction)actionRequestRide:(UIButton *)sender {
    
    [self uber];
}


- (void)uber{
    [[UIPasteboard generalPasteboard] setString:@"THE_PROMO_CODE"]; //be sure this is clearly labeled in the UI to prevent inadventent data loss callback://CityBud
    
    NSURL* uberURL = [NSURL URLWithString:@"uber://?client_id=7OPAudiPnNjwYA--yg-osO7D7Ec7Yhu-&action=setPickup&pickup=30.7046&pickup=76.7179&pickup=Mohali_Pind&pickup=1356%20Phase%203B2%20Mohali&dropoff=30.6942&dropoff=76.8606&dropoff=Coit%20Tower&dropoff=1%20Telegraph%20Hill%20Blvd%2C%20San%20Francisco%2C%20CA%2094133&product_id=a1111c8c-c720-46c3-8534-2fcdd730040d&link_text=View%20team%20roster"];
    NSURL* appStoreURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/uber/id368677368?mt=8"];
    
    if ([[UIApplication sharedApplication] canOpenURL:uberURL])
    {
        [[UIApplication sharedApplication] openURL:uberURL];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:appStoreURL];
    }
}



@end
