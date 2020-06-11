//
//  PayStackPayController.m
//  CityBud
//
//  Created by Apple on 25/04/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "PayStackPayController.h"
#import "STMethod.h"

@interface PayStackPayController ()

@end

@implementation PayStackPayController
@synthesize PaymentDetailArr,eventID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.paymentTextField.delegate = self;
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"]);
    
    if (IS_IPHONE4_OR_4S || IS_IPHONE5_OR_5S)
    {
        upper_height.constant = 80;
    }
    else if (IS_IPHONE6 )
    {
        upper_height.constant = 200;
    }
    else if (IS_IPHONE6pluse)
    {
        upper_height.constant = 225;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)BackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)paymentCardTextFieldDidChange:(PSTCKPaymentCardTextField *)textField
{
    // Toggle navigation, for example
    self.PayButton.enabled = textField.isValid;
}

-(IBAction)PayButonClick:(UIButton*)sender
{
    if (_paymentTextField.isValid == false)
    {
        [STMethod showAlert:self Title:appNAME Message:@"Sorry, Check your card information." ButtonTitle:@"Ok"];
        return;
    }
    else
    {
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus==AFNetworkReachabilityStatusNotReachable)
        {
            return;
        }
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:SCREEN_WINDOW animated:YES];
        HUD.labelFont = [UIFont fontWithName:Helvetica size:18.0f];
        HUD.labelText = @"Loading...";
        
        //Transection Parameters
        PSTCKTransactionParams *transactionParams = [[PSTCKTransactionParams alloc] init];
        
        NSUInteger  tempInt = 0;
        
        for (int i = 0; i< [PaymentDetailArr count]; i++)
        {
            if ([[NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"is_seleted"]] isEqualToString:@"yes"])
            {
                NSUInteger   tempPrice = [[NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"TotalPrice"]] integerValue];
                
                if (tempPrice >0 )
                {
                    tempInt = tempInt + tempPrice;
                }
            }
        }
        tempInt = tempInt * 100;
        
        transactionParams.amount = tempInt;
        
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"] valueForKey:@"email"]]])
        {
            transactionParams.email = @"iglobsyn@gmail.com";
        }
        else
        {
            transactionParams.email = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"] valueForKey:@"email"];
        }
        
        // transactionParams.subaccount  = @"ACCT_80d907euhish8d";
        // transactionParams.bearer  = @"subaccount";
        //  transactionParams.transaction_charge  = 280*100;
        // transactionParams.reference = @"ChargedFromiOSSDK";
        
        //Card Parameters
        PSTCKCardParams *cardParams = [[PSTCKCardParams alloc] init];
        cardParams.number = [_paymentTextField cardNumber];
        cardParams.cvc = [_paymentTextField cvc];
        cardParams.expYear = [_paymentTextField expirationYear];
        cardParams.expMonth = [_paymentTextField expirationMonth];
        
        [[PSTCKAPIClient sharedClient]chargeCard:cardParams forTransaction:transactionParams onViewController:self didEndWithError:^(NSError * _Nonnull error, NSString * _Nullable reference)
         {
             // Handel Error
             NSLog(@"Error : %@",error.localizedDescription);
             
             HIDE_LOADING();
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [UIAlertController alertControllerWithTitle:@"Error" message:@"Sorry, Check your card information." buttonTitle:@"OK" viewController:self alertAction:^(UIAlertAction *action) {
                 }];
             });
             
         } didRequestValidation:^(NSString * _Nonnull reference)
         {
             // an OTP was requested, transaction has not yet succeeded
             NSLog(@"Validation OTP : %@",reference);
         } didTransactionSuccess:^(NSString * _Nonnull reference2)
         {
             // transaction may have succeeded, please verify on server
             NSLog(@"Transaction Success : %@",reference2);
             transactionID = reference2;
             
             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.paystack.co/transaction/verify/%@",reference2]];
             
             NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
             
             request.HTTPMethod = @"GET";
             
             [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
             
             // live key
               [request addValue:@"Bearer sk_live_297d10099b3f7d32a8c7fade1d38732287eb6b20" forHTTPHeaderField:@"authorization"];
             
             // test key
           // [request addValue:@"Bearer sk_test_89b7b2a9fa9e9d863caa3a25ce211c31f62e3e23" forHTTPHeaderField:@"authorization"];
             
             NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
             
             NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
             NSURLSessionDataTask *task =
             [session dataTaskWithRequest:request
                        completionHandler:^(NSData *data,
                                            NSURLResponse *response,
                                            NSError *error)
              {
                  if (error)
                  {
                      //Error for verify server
                      NSLog(@"Error :%@",error.localizedDescription);
                  }
                  else
                  {
                      NSError *ER;
                      
                      NSDictionary *ResponseDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&ER];
                      
                      if (ER==nil)
                      {
                          NSLog(@"Final Response Dictionary : %@",ResponseDic);
                          
                          NSString *Status=[NSString stringWithFormat:@"%@",[ResponseDic valueForKey:@"status"]];
                          
                          if ([Status isEqualToString:@"1"] || [Status isEqualToString:@"true"])
                          {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  //                              HIDE_LOADING();
                                  //                             [UIAlertController alertControllerWithTitle:@"Error" message:@"Transaction Successfull" buttonTitle:@"OK" viewController:self alertAction:^(UIAlertAction *action) {
                                  //                                 [self.navigationController popViewControllerAnimated:true];
                                  //                             }];
                                  
                                  [self paymentWebserviceCall];
                              });
                              
                          }
                          else
                          {
                              HIDE_LOADING();
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  HIDE_LOADING();
                                  [UIAlertController alertControllerWithTitle:@"Error" message:@"Transaction failed,Please try again." buttonTitle:@"OK" viewController:self alertAction:^(UIAlertAction *action) {
                                  }];
                              });
                          }
                          //successfully
                      }
                      else
                      {
                          NSLog(@"Error : %@",ER.localizedDescription);
                          HIDE_LOADING();
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [UIAlertController alertControllerWithTitle:@"Error" message:@"Transaction failed,Please try again." buttonTitle:@"OK" viewController:self alertAction:^(UIAlertAction *action) {
                              }];
                          });
                      }
                  }
              }];
             [task resume];
             
         }];
    }
}

#pragma mark - payment webservice
-(void)paymentWebserviceCall
{
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        SHOW_NETWORK_ERROR_ALERT();
        return;
    } else {
        
        NSString * RegularType, *RegularPrice, *RegularTickets;
        NSString * VIPType, *VIPPrice, *VIPTickets;
        NSString * VVIPType, *VVIPPrice, *VVIPTickets;
        
        RegularType  = @"";
        RegularPrice = @"0";
        RegularTickets = @"0";
        VIPType  = @"";
        VIPPrice = @"0";
        VIPTickets = @"0";
        VVIPType  = @"";
        VVIPPrice = @"0";
        VVIPTickets = @"0";
        
        for (int i = 0; i< [PaymentDetailArr count]; i++)
        {
            if ([[NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"Title"]] isEqualToString:@"Regular"])
            {
                if ([[NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"is_seleted"]] isEqualToString:@"yes"])
                {
                    RegularType  = @"yes";
                    RegularPrice = [NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"TotalPrice"]];
                    RegularTickets = [NSString stringWithFormat:@"%@",[[PaymentDetailArr  objectAtIndex:i] valueForKey:@"UserSelcetedTicketCount"]];
                }
            }
            
            if ([[NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"Title"]] isEqualToString:@"VIP"])
            {
                if ([[NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"is_seleted"]] isEqualToString:@"yes"])
                {
                    VIPType  = @"yes";
                    VIPPrice = [NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"TotalPrice"]];
                    VIPTickets = [NSString stringWithFormat:@"%@",[[PaymentDetailArr  objectAtIndex:i] valueForKey:@"UserSelcetedTicketCount"]];
                }
            }
            
            if ([[NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"Title"]] isEqualToString:@"VVIP"])
            {
                if ([[NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"is_seleted"]] isEqualToString:@"yes"])
                {
                    VVIPType  = @"yes";
                    VVIPPrice = [NSString stringWithFormat:@"%@",[[PaymentDetailArr objectAtIndex:i] valueForKey:@"TotalPrice"]];
                    VVIPTickets = [NSString stringWithFormat:@"%@",[[PaymentDetailArr  objectAtIndex:i] valueForKey:@"UserSelcetedTicketCount"]];
                }
            }
        }
        
        
        WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
        inputParam.webserviceRelativePath = @"buyTicket.php";
        inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
        inputParam.dictPostParameters = [@{
                                           @"event_id" : eventID,
                                           @"user_id" : [USUserInfoModel sharedInstance].user_id,
                                           @"payment_type" : @"1",
                                           @"transition_id" : transactionID,
                                           @"device_type": @"ios",
                                           @"ticket_type_regular" : [NSString stringWithFormat:@"%@",RegularType],
                                           @"ticket_type_vip" : [NSString stringWithFormat:@"%@",VIPType],
                                           @"ticket_type_vvip" : [NSString stringWithFormat:@"%@",VVIPType],
                                           @"ticket_number_regular" : [NSString stringWithFormat:@"%@",RegularTickets],
                                           @"ticket_number_vip" : [NSString stringWithFormat:@"%@",VIPTickets],
                                           @"ticket_number_vvip" : [NSString stringWithFormat:@"%@",VVIPTickets],
                                           @"ticket_price_regular" : [NSString stringWithFormat:@"%@",RegularPrice],
                                           @"ticket_price_vip" : [NSString stringWithFormat:@"%@",VIPPrice],
                                           @"ticket_price_vvip" : [NSString stringWithFormat:@"%@",VVIPPrice]
                                           } mutableCopy];
        
        NSLog(@"%@",inputParam.dictPostParameters);
        
        [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
            
            NSLog(@"response==>%@",response);
            
            HIDE_LOADING();
            
            if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
                HIDE_LOADING();
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIAlertController alertControllerWithTitle:@"Payment" message:@"Transaction Successfull" buttonTitle:@"OK" viewController:self alertAction:^(UIAlertAction *action) {
                        
                        NSMutableDictionary *dict = [[response valueForKey:@"body"] mutableCopy];
                        
                        APPDELEGATE.attendingPeople = [dict valueForKey:@"peoples_attending"];
                    
                        UINavigationController * Nav=self.tabBarController.selectedViewController;
                        
                        [self.tabBarController setSelectedIndex:2];
                        
                        [Nav popToRootViewControllerAnimated:false];
                        
                    }];
                });
                
            } else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"])
            {
                HIDE_LOADING();
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIAlertController alertControllerWithTitle:@"Error" message:@"Transaction failed,Please try again." buttonTitle:@"OK" viewController:self alertAction:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:true];                                                    }];
                });
            }
            
        } error:^(id response, NSError *error) {
            
            HIDE_LOADING();
            
            NSLog(@"%@",error.userInfo);
        }];
    }
}

@end
