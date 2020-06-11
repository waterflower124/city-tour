//
//  CBBuyedTicketDetailViewController.m
//  CityBud
//
//  Created by Vikas Singh on 04/10/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBBuyedTicketDetailViewController.h"
#import "BuyedTicketDetailCell.h"
#import "STMethod.h"

@interface CBBuyedTicketDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * DropdownArr;
}

@end

@implementation CBBuyedTicketDetailViewController
@synthesize TicketDetailDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // event image
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[TicketDetailDict valueForKey:@"event_pic"]]]==false)
    {
        
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[TicketDetailDict valueForKey:@"event_pic"]]];
       
        
        imageViewEvent.image = [UIImage imageWithData: imageData];
        
       // imageViewEvent.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[NSURL URLWithString:[TicketDetailDict valueForKey:@"event_pic"]]]];
    }
    else
    {
        imageViewEvent.image = [UIImage imageNamed:@"logo"];
    }
    
    // event name adress
    NSString * eventName;
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[TicketDetailDict valueForKey:@"event_name"]]]==false)
    {
        eventName = [NSString stringWithFormat:@"%@",[TicketDetailDict valueForKey:@"event_name"]];
    }
    else
    {
        eventName = @"";
    }
    
    NSString * eventVenue;
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[TicketDetailDict valueForKey:@"event_venue"]]]==false)
    {
        eventVenue = [NSString stringWithFormat:@"%@",[TicketDetailDict valueForKey:@"event_venue"]];
    }
    else
    {
        eventVenue = @"";
    }
    
    NSString * eventAddress;
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[TicketDetailDict valueForKey:@"event_address"]]]==false)
    {
        eventAddress = [NSString stringWithFormat:@"%@",[TicketDetailDict valueForKey:@"event_address"]];
    }
    else
    {
        eventAddress = @"";
    }
    
    labelEventAddress.text = [NSString stringWithFormat:@"%@ | %@ - %@",eventName,eventVenue,eventAddress];
    
    
    // event date time
    NSString * eventDate;
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[self getDateFromDateDtring:TicketDetailDict[@"event_date"]]]]==false)
    {
        eventDate = [NSString stringWithFormat:@"%@",[self getDateFromDateDtring:TicketDetailDict[@"event_date"]]];
    }
    else
    {
        eventDate = @"";
    }
    
    NSString *sDate;
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",TicketDetailDict[@"event_time"]]]==false)
    {
        sDate = [NSString stringWithFormat:@"%@",TicketDetailDict[@"event_time"]];
    }
    else
    {
        sDate =@"";
    }
    
    NSString *eDate;
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",TicketDetailDict[@"event_endtime"]]]==false)
    {
        eDate = [NSString stringWithFormat:@"%@",TicketDetailDict[@"event_endtime"]];
    }
    else
    {
        eDate = @"";
    }
    
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[[NSString stringWithFormat:@"%@ %@ - %@",eventDate,sDate,eDate] uppercaseString]];
    
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [[NSString stringWithFormat:@"%@ %@ - %@",eventDate,sDate,eDate] length])];
    
    
    labelDate.attributedText = attributedString;
    
    // refrence number
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",TicketDetailDict[@"transition_id"]]]==false)
    {
        refrenceNumber.text = [NSString stringWithFormat:@"%@",TicketDetailDict[@"transition_id"]];
    }
    else
    {
        refrenceNumber.text = @"";
    }
    
    //number of ticket
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",TicketDetailDict[@"no_of_ticket"]]]==false)
    {
        numberOfTicket.text = [NSString stringWithFormat:@"%@",TicketDetailDict[@"no_of_ticket"]];
    }
    else
    {
        numberOfTicket.text = @"";
    }
    
    //total price
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",TicketDetailDict[@"total_price"]]]==false)
    {
        totalPrice.text = [NSString stringWithFormat:@"%@",TicketDetailDict[@"total_price"]];
    }
    else
    {
        totalPrice.text = @"";
    }
    
}

-(NSString *) getDateFromDateDtring:(NSString *)dateString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];   //
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];  // remove this is you want to pass an NSDate as parameter.
    
    NSString *formatterCheck= [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    
    if ([formatterCheck containsString:@"a"])
    {
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    }
    else
    {
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    df.calendar=NSCalendar.currentCalendar;
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [df setTimeZone:gmt];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *local = [NSTimeZone localTimeZone];
//    [dateFormatter setTimeZone:local];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:dateString];
    
    [df setDateFormat:@"E, MMM dd"];
    
    NSString *dateStr = [df stringFromDate:date];
    
    return dateStr;
}

-(NSString *) getTimeFromTimeString:(NSString *)timeString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];   //
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];  // remove this is you want to pass an NSDate as parameter.
    
    NSString *formatterCheck= [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    
    if ([formatterCheck containsString:@"a"])
    {
        [df setDateFormat:@"h:mm a"];
    }
    else
    {
        [df setDateFormat:@"HH:mm"];
    }
    
    df.calendar=NSCalendar.currentCalendar;
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [df setTimeZone:gmt];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *local = [NSTimeZone localTimeZone];
//    [dateFormatter setTimeZone:local];

    NSDate *date = [df dateFromString:timeString];
    
    [df setDateFormat:@"HH:mm"];
    
    NSString *timeStr = [df stringFromDate:date];
    
    return timeStr;
}

-(void)viewWillAppear:(BOOL)animated
{
    DropdownArr = [NSMutableArray arrayWithCapacity:3];
    
    NSString * regularTicket = [NSString stringWithFormat:@"%@",TicketDetailDict[@"ticket_type_regular"]];
    
    if ([regularTicket isEqualToString:@"yes"])
    {
        NSMutableDictionary * Regular =[NSMutableDictionary new];
        
        [Regular setValue:@"Regular" forKey:@"Title"];
        
        [Regular setValue:@"availble" forKey:@"ticket_type_regular"];
        
        [Regular setValue:TicketDetailDict[@"ticket_number_regular"] forKey:@"TotalAvaibleTicket"];
        
        [Regular setValue:TicketDetailDict[@"ticket_price_regular"] forKey:@"PerTicketPrice"];
        
        [DropdownArr addObject:Regular];
    }
    
    NSString * VIPTicket = [NSString stringWithFormat:@"%@",TicketDetailDict[@"ticket_type_vip"]];
    
    if ([VIPTicket isEqualToString:@"yes"])
    {
        NSMutableDictionary * VIP = [NSMutableDictionary new];
        
        [VIP setValue:@"VIP" forKey:@"Title"];
        
        [VIP setValue:@"availble" forKey:@"ticket_type_vip"];
        
        [VIP setValue:TicketDetailDict[@"ticket_number_vip"] forKey:@"TotalAvaibleTicket"];
        
        [VIP setValue:TicketDetailDict[@"ticket_price_vip"] forKey:@"PerTicketPrice"];
        
        [VIP setValue:TicketDetailDict[@"ticket_price_vip"] forKey:@"TotalPrice"];
        
        [DropdownArr addObject:VIP];
    }
    
    NSString * VVIPTicket = [NSString stringWithFormat:@"%@",TicketDetailDict[@"ticket_type_vvip"]];
    
    if ([VVIPTicket isEqualToString:@"yes"])
    {
        NSMutableDictionary * VVIP = [NSMutableDictionary new];
        
        [VVIP setValue:@"VVIP" forKey:@"Title"];
        
        [VVIP setValue:@"availble" forKey:@"ticket_type_vvip"];
        
        [VVIP setValue:TicketDetailDict[@"ticket_number_vvip"]
                forKey:@"TotalAvaibleTicket"];
        
        [VVIP setValue:TicketDetailDict[@"ticket_price_vvip"] forKey:@"PerTicketPrice"];
        
        [VVIP setValue:TicketDetailDict[@"ticket_price_vvip"] forKey:@"TotalPrice"];
        
        [DropdownArr addObject:VVIP];
    }
    
    if (DropdownArr.count == 0)
    {
        
    }
    
    else if (DropdownArr.count == 1)
    {
        tableHeight.constant = 85;
    }
    else if (DropdownArr.count == 2)
    {
        tableHeight.constant = 129;
    }
    else if (DropdownArr.count == 3)
    {
        tableHeight.constant = 173;
    }
    
    NSLog(@"DropdownArr = %@",DropdownArr);
}

#pragma mark - table methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return DropdownArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyedTicketDetailCell * categoryCell = [tableView  dequeueReusableCellWithIdentifier:@"BuyedTicketDetailCell"];
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"Title"]]]==false)
    {
        categoryCell.TicketCategorylabel.text = [NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"Title"]];
    }
    else
    {
        categoryCell.TicketCategorylabel.text = @"";
    }
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"TotalAvaibleTicket"]]]==false)
    {
        categoryCell.numberofTicket.text = [NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"TotalAvaibleTicket"]];
    }
    else
    {
        categoryCell.numberofTicket.text =  @"";
    }
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"TotalAvaibleTicket"]]]==false && [STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"PerTicketPrice"]]]==false)
    {
        int ticketPrice = [[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"PerTicketPrice"]] intValue];
        
        int totalTicket = [[NSString stringWithFormat:@"%@",[[DropdownArr objectAtIndex:indexPath.row] valueForKey:@"TotalAvaibleTicket"]] intValue];
        
        int totalPrice = ticketPrice * totalTicket;
        
        categoryCell.totalPrice.text = [NSString stringWithFormat:@"%d",ticketPrice];
    }
    else
    {
        categoryCell.totalPrice.text = @"";
    }
    
    return categoryCell;
}

#pragma mark - back button click
-(IBAction)BackButtonClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
