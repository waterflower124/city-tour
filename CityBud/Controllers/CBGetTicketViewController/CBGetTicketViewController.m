//
//  CBGetTicketViewController.m
//  CityBud
//
//  Created by Vikas Singh on 19/06/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBGetTicketViewController.h"
#import "PayStackPayController.h"
#import "Passkit/Passkit.h"
#import "Constants.h"
#import "STMethod.h"

#import "TicketTypeCell.h"
#import "TotalPriceCell.h"

@interface CBGetTicketViewController ()<UITextFieldDelegate>
{
    NSInteger  GrandTotal;
}
@end

@implementation CBGetTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GrandTotal = 0;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([AFNetworkReachabilityManager sharedManager].isReachable){
        SHOW_NETWORK_ERROR_ALERT();
        return;
    }else{
        
        [self callGetTicketAvailabiltyWebservice];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get ticket status

- (void)callGetTicketAvailabiltyWebservice{
    
    [self hideKeyboard];
    
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"check_available.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.dictPostParameters = _dictParamForGetTicket;
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"Search Response==>%@",response);
        
        if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
            self.arrSearchResult = [NSMutableArray new];
            self.arrSearchResult = [[response valueForKey:@"body"] mutableCopy];
            
            ticketPriceUpdateDict = [NSMutableDictionary new];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                HIDE_LOADING();
                
                if ([_arrSearchResult count] > 0){
                    
                    NSLog(@"%@",[_arrSearchResult objectAtIndex:0]);
                    
                    DropdownArr = [NSMutableArray arrayWithCapacity:3];
                    
                    NSString *PriceR = [NSString stringWithFormat:@"%@", [[_arrSearchResult objectAtIndex:0] valueForKey:@"ticket_price_regular"]];
                    NSString *PriceV = [NSString stringWithFormat:@"%@", [[_arrSearchResult objectAtIndex:0] valueForKey:@"ticket_price_vip"]];
                    NSString *PriceVV = [NSString stringWithFormat:@"%@", [[_arrSearchResult objectAtIndex:0] valueForKey:@"ticket_price_vvip"]];
     
                    NSString * regularTicket = [NSString stringWithFormat:@"%@",[[_arrSearchResult objectAtIndex:0]valueForKey:@"ticket_type_regular"]];
                    
                    if ([regularTicket isEqualToString:@"yes"])
                    {
                        NSMutableDictionary * Regular =[NSMutableDictionary new];
                        [Regular setValue:@"Regular" forKey:@"Title"];
                        
                        [Regular setValue:@"availble" forKey:@"ticket_type_regular"];
                        
                        [Regular setValue:[[self.arrSearchResult objectAtIndex:0] valueForKey:@"ticket_number_regular"] forKey:@"TotalAvaibleTicket"];
                        
                        [Regular setValue:[[self.arrSearchResult objectAtIndex:0] valueForKey:@"ticket_price_regular"] forKey:@"PerTicketPrice"];
                        
                        [Regular setValue:[[self.arrSearchResult objectAtIndex:0] valueForKey:@"ticket_price_regular"] forKey:@"TotalPrice"];
                        
                        [Regular setValue:@"1" forKey:@"UserSelcetedTicketCount"];
                        
                        [Regular setValue:@"no" forKey:@"is_seleted"];
                        
                        [DropdownArr addObject:Regular];
                    }
                    
                    NSString * VIPTicket = [NSString stringWithFormat:@"%@",[[_arrSearchResult objectAtIndex:0] valueForKey:@"ticket_type_vip"]];
                    
                    if ([VIPTicket isEqualToString:@"yes"])
                    {
                        NSMutableDictionary * VIP = [NSMutableDictionary new];
                        
                        [VIP setValue:@"VIP" forKey:@"Title"];
                        
                        [VIP setValue:@"availble" forKey:@"ticket_type_vip"];
                        
                        [VIP setValue:[[self.arrSearchResult objectAtIndex:0] valueForKey:@"ticket_number_vip"] forKey:@"TotalAvaibleTicket"];
                        
                        [VIP setValue:[[self.arrSearchResult objectAtIndex:0] valueForKey:@"ticket_price_vip"] forKey:@"PerTicketPrice"];
                        
                        [VIP setValue:[[self.arrSearchResult objectAtIndex:0] valueForKey:@"ticket_price_vip"] forKey:@"TotalPrice"];
                        
                        [VIP setValue:@"1" forKey:@"UserSelcetedTicketCount"];
                        
                        [VIP setValue:@"no" forKey:@"is_seleted"];
                        
                        [DropdownArr addObject:VIP];
                    }
                    
                    NSString * VVIPTicket = [NSString stringWithFormat:@"%@",[[_arrSearchResult objectAtIndex:0] valueForKey:@"ticket_type_vvip"]];
                    
                    if ([VVIPTicket isEqualToString:@"yes"])
                    {
                        NSMutableDictionary * VVIP = [NSMutableDictionary new];
                        
                        [VVIP setValue:@"VVIP" forKey:@"Title"];
                        
                        [VVIP setValue:@"availble" forKey:@"ticket_type_vvip"];
                        
                        [VVIP setValue:[[self.arrSearchResult objectAtIndex:0] valueForKey:@"ticket_number_vvip"] forKey:@"TotalAvaibleTicket"];
                        
                        [VVIP setValue:[[self.arrSearchResult objectAtIndex:0] valueForKey:@"ticket_price_vvip"] forKey:@"PerTicketPrice"];
                        
                        [VVIP setValue:[[self.arrSearchResult objectAtIndex:0] valueForKey:@"ticket_price_vvip"] forKey:@"TotalPrice"];
                        
                        [VVIP setValue:@"1" forKey:@"UserSelcetedTicketCount"];
                        
                        [VVIP setValue:@"no" forKey:@"is_seleted"];
                        
                        [DropdownArr addObject:VVIP];
                    }
                    
                    if (DropdownArr.count == 0)
                    {
                        payStackButton.userInteractionEnabled = false;
                        
                        [STMethod showAlert:self Title:appNAME Message:@"Sorry, there are not currently any tickets for this event" ButtonTitle:@"OK"];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        return ;
                        
                    }
                    
                    else if (DropdownArr.count == 1)
                    {
                        tableHeight.constant = 127;
                    }
                    else if (DropdownArr.count == 2)
                    {
                        tableHeight.constant = 171;
                    }
                    else if (DropdownArr.count == 3)
                    {
                        tableHeight.constant = 215;
                    }
                    
                    NSLog(@"DropdownArr = %@",DropdownArr);
                    
                    
                    
                    
                    if ([PriceR isEqualToString:@"0"] && [PriceV isEqualToString:@"0"] && [PriceVV isEqualToString:@"0"]) {
                        
                        [payStackButton setTitle:@"Get Ticket" forState:UIControlStateNormal];
                        
                    }
                    
                    [ticketTypeTable reloadData];
                    
                }else
                {
                    [UIAlertController showAlertWithTitle:appNAME message:@"No result found" onViewController:self];
                }
            });
        }
        
    } error:^(id response, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}

#pragma mark - table methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return DropdownArr.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        TicketTypeCell * categoryCell = [tableView  dequeueReusableCellWithIdentifier:@"TicketTypeCell"];
        
        categoryCell.TicketCategorylabel.text = [NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"Title"]];
        
        categoryCell.numberofTicket.text = [NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"UserSelcetedTicketCount"]];
        
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"TotalPrice"]]])
        {
            categoryCell.totalPrice.text = [NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"PerTicketPrice"]];
        }
        else
        {
            categoryCell.totalPrice.text = [NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"TotalPrice"]];
        }
        
        categoryCell.numberofTicket.tag = indexPath.row;
        
        [categoryCell.numberofTicket addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
        
        if ([[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"is_seleted"] isEqualToString:@"yes"])
        {
            [categoryCell.checkboxBtn setImage:[UIImage imageNamed:@"checkbox_filled"] forState:UIControlStateNormal];
        }
        else
        {
            [categoryCell.checkboxBtn setImage:[UIImage imageNamed:@"checkbox_blank"] forState:UIControlStateNormal];
        }
        
        categoryCell.checkboxBtn.tag = indexPath.row;
        
        [categoryCell.checkboxBtn addTarget:self action:@selector(checkboxButton_click:) forControlEvents:UIControlEventTouchUpInside];
        
        if (IS_IPHONE4_OR_4S)
        {
            categoryCell.checkboxBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        }
        return categoryCell;
    }
    else
    {
        TotalPriceCell *  totalPriceCell = [tableView dequeueReusableCellWithIdentifier:@"TotalPriceCell"];
        
        //        NSInteger totalPrice = 0;
        //
        //        for (int i = 0; i < [DropdownArr count]; i++)
        //        {
        //            NSInteger tempPrice = 0;
        //
        //            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"TotalPrice"]]])
        //            {
        //                tempPrice = [[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"PerTicketPrice"]] integerValue];
        //            }
        //            else
        //            {
        //                tempPrice = [[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"TotalPrice"]] integerValue];
        //            }
        //
        //            totalPrice = totalPrice + tempPrice;
        //        }
        
        totalPriceCell.totalPrice.text =[NSString stringWithFormat:@"%ld",GrandTotal];
        
        return totalPriceCell;
    }
    
    return nil;
}


#pragma mark - Paystack button click
- (IBAction)PayStackButton:(UIButton *)sender {
    
    [self hideKeyboard];
    
    [self getNumberOfPeoplesGoingAndTicketType];
    
    NSLog(@"%@",DropdownArr);
    
    if([sender.titleLabel.text isEqualToString:@"Get Ticket"]){
        
        [self paymentWebserviceCall];
        
    }else{
        
        PayStackPayController *PayViaStackViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"PayStackPayController"];
        
        PayViaStackViewController.PaymentDetailArr = [[NSMutableArray alloc] initWithArray:DropdownArr];
        
        PayViaStackViewController.eventID = [NSString stringWithFormat:@"%@",[_dictParamForGetTicket valueForKey:@"event_id"]];
        
        [self.navigationController pushViewController:PayViaStackViewController animated:true];
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
        
        for (int i = 0; i< [DropdownArr count]; i++)
        {
            if ([[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"Title"]] isEqualToString:@"Regular"])
            {
                if ([[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"is_seleted"]] isEqualToString:@"yes"])
                {
                    RegularType  = @"yes";
                    RegularPrice = [NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"TotalPrice"]];
                    RegularTickets = [NSString stringWithFormat:@"%@",[[DropdownArr  objectAtIndex:i] valueForKey:@"UserSelcetedTicketCount"]];
                }
            }
            
            if ([[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"Title"]] isEqualToString:@"VIP"])
            {
                if ([[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"is_seleted"]] isEqualToString:@"yes"])
                {
                    VIPType  = @"yes";
                    VIPPrice = [NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"TotalPrice"]];
                    VIPTickets = [NSString stringWithFormat:@"%@",[[DropdownArr  objectAtIndex:i] valueForKey:@"UserSelcetedTicketCount"]];
                }
            }
            
            if ([[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"Title"]] isEqualToString:@"VVIP"])
            {
                if ([[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"is_seleted"]] isEqualToString:@"yes"])
                {
                    VVIPType  = @"yes";
                    VVIPPrice = [NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"TotalPrice"]];
                    VVIPTickets = [NSString stringWithFormat:@"%@",[[DropdownArr  objectAtIndex:i] valueForKey:@"UserSelcetedTicketCount"]];
                }
            }
        }
        
        NSString *eventIDStr = [NSString stringWithFormat:@"%@",[_dictParamForGetTicket valueForKey:@"event_id"]];
        int number = arc4random_uniform(900000) + 100000;
        NSString *transactionID = [NSString stringWithFormat:@"%d",number];
        
        WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
        inputParam.webserviceRelativePath = @"buyTicket.php";
        inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
        inputParam.dictPostParameters = [@{
                                           @"event_id" : eventIDStr,
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
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"afterTicketPurchase" object:nil];
                        
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

#pragma mark - get number of people and type of ticket
-(void)getNumberOfPeoplesGoingAndTicketType
{
    NSInteger ticketTypes = DropdownArr.count;
    
    NSMutableArray * SelcetedticketTypeArr = [NSMutableArray new];
    
    for (int i =0; i < ticketTypes; i++)
    {
        if ([[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"is_seleted"]] isEqualToString:@"yes"])
        {
            [SelcetedticketTypeArr addObject:[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"Title"]]];
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"UserSelcetedTicketCount"]]])
            {
                [STMethod showAlert:self Title:appNAME Message:@"Enter atleast one ticket" ButtonTitle:@"OK"];
                return;
            }
        }
    }
    
    if (SelcetedticketTypeArr.count < 1)
    {
        [STMethod showAlert:self Title:appNAME Message:@"Please select atleast one type of ticket" ButtonTitle:@"OK"];
        
        return;
    }
}

#pragma mark - checkbox button click
-(IBAction)checkboxButton_click:(UIButton *)sender
{
    NSMutableDictionary *TempDic=[[NSMutableDictionary alloc]initWithDictionary:[DropdownArr objectAtIndex:sender.tag]];
    
    if ([[NSString stringWithFormat:@"%@",[TempDic valueForKey:@"is_seleted"]] isEqualToString:@"yes"])
    {
        [TempDic setValue:@"no" forKey:@"is_seleted"];
    }
    else
    {
        [TempDic setValue:@"yes" forKey:@"is_seleted"];
    }
    
    [DropdownArr replaceObjectAtIndex:sender.tag withObject:TempDic];
    //
    
    [self totalPriceUpdate];
    
    [ticketTypeTable reloadData];
}

#pragma mark - textfield delegate
-(void)textFieldDidChange :(UITextField *)sender
{
    NSMutableDictionary * tempDic = [[NSMutableDictionary alloc] initWithDictionary:[DropdownArr  objectAtIndex:sender.tag]];
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",sender.text]] || [[NSString stringWithFormat:@"%@",sender.text] isEqualToString:@"1"] ||[[NSString stringWithFormat:@"%@",sender.text] integerValue]<1)
    {
        sender.text = @"1";
    }
    
    if ([(sender.text)integerValue] < [[[DropdownArr objectAtIndex:sender.tag] valueForKey:@"TotalAvaibleTicket"] integerValue])
    {
        [tempDic setValue:sender.text forKey:@"UserSelcetedTicketCount"];
        
        NSInteger  TotalTickets = [(sender.text)integerValue];
        
        NSInteger TotalPrice = [[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:sender.tag] valueForKey:@"PerTicketPrice"]] integerValue];
        
        NSInteger finalPrice = TotalPrice * TotalTickets;
        
        [tempDic setValue:[NSString stringWithFormat:@"%ld",(long)finalPrice] forKey:@"TotalPrice"];
        
        [DropdownArr replaceObjectAtIndex:sender.tag withObject:tempDic];
        //
        
        [self totalPriceUpdate];
        [ticketTypeTable reloadData];
    }
    else
    {
        [STMethod showAlert:self Title:appNAME Message:[NSString stringWithFormat:@"Only %@ tickets availbale for %@",[tempDic valueForKey:@"TotalAvaibleTicket"], [tempDic valueForKey:@"Title"] ]ButtonTitle:@"OK"];
        
        return;
    }
}

#pragma mark - Total Price Update
-(void)totalPriceUpdate
{
    NSInteger tempTotal = 0;

    for (int i = 0; i < [DropdownArr count]; i++)
    {
        NSInteger tempPrice = 0;
        
        if ([[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"is_seleted"]] isEqualToString:@"yes"])
        {
            tempPrice = [[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:i] valueForKey:@"TotalPrice"]] integerValue];
            
            tempTotal = tempTotal + tempPrice;
        }
    }
    
    if (tempTotal > 0)
    {
        GrandTotal = tempTotal;
    }
    else
    {
        GrandTotal = 0;
    }
    
}

#pragma mark - back button click
- (IBAction)BackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LocalMethods

-(void)hideKeyboard
{
    [self.view endEditing:YES];
}

@end
