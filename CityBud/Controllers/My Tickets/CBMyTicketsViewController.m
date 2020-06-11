//
//  CBMyTicketsViewController.m
//  CityBud
//
//  Created by Vikas Singh on 04/07/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBMyTicketsViewController.h"
#import "STMethod.h"
#import "Constants.h"
#import "MyTicketListCell.h"
#import "CBBuyedTicketDetailViewController.h"
#import <CoreText/CTStringAttributes.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface CBMyTicketsViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSMutableArray * TicketHistoryListArr;
    UIRefreshControl *refreshControl;
}
@end

@implementation CBMyTicketsViewController
@synthesize TicketHistoryListTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TicketHistoryListTable.estimatedRowHeight = 140;
    TicketHistoryListTable.rowHeight = UITableViewAutomaticDimension;
    refreshControl = [[UIRefreshControl alloc]init];[TicketHistoryListTable addSubview:refreshControl];    [refreshControl addTarget:self action:@selector(pullDownToRefresh) forControlEvents:UIControlEventValueChanged];
}

-(void)pullDownToRefresh
{
    [self getMyTicketHistoryWebserviceCall];    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getMyTicketHistoryWebserviceCall];
}

#pragma mark - Table View Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TicketHistoryListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyTicketListCell * Listcell = [tableView dequeueReusableCellWithIdentifier:@"MyTicketListCell"];
   
    // event image
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_pic"]]]==false)
    {
        NSString *ImageUrlStr=[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_pic"]];
        
        ImageUrlStr = [ImageUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

         [Listcell.EventImage sd_setImageWithURL:[NSURL URLWithString:ImageUrlStr] placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageRefreshCached];
    }
    else
    {
        Listcell.EventImage.image = [UIImage imageNamed:@"logo"];
    }
    
    // event name
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_name"]]]==false)
    {
        Listcell.EventName.text = [NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_name"]];
    }
    else
    {
        Listcell.EventName.text = @"";
    }
    
    // event address
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_venue"]]]==false)
    {
        Listcell.EventAddress.text = [NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_address"]];
        
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_address"]]]==false)
        {
             Listcell.EventAddress.text = [NSString stringWithFormat:@"%@,%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_venue"],[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_address"]]];
        }
        else
        {
            Listcell.EventAddress.text = [NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_venue"]];
        }
    }
    else
    {
        Listcell.EventAddress.text = @"";
    }
    
    //No of ticket
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"no_of_ticket"]]]==false)
    {       
        Listcell.NoofTicket.text = [NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"no_of_ticket"]];
    }
    else
    {
        Listcell.NoofTicket.text = @"";
    }
    
    //Total price
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"total_price"]]]==false)
    {
        Listcell.TotalPrice.text = [NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"total_price"]];
    }
    else
    {
        Listcell.TotalPrice.text = @"";
    }
    
    //Date
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_date"]]]==false)
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

        NSDate *Monthdate = [df dateFromString:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_date"]]];
        
        NSDate *date = [df dateFromString:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_date"]]];
        
        [df setDateFormat:@"MMM"];
        
        NSString *MonthStr = [[df stringFromDate:Monthdate] uppercaseString];
       
        [df setDateFormat:@"dd"];
        
        NSString *dateString = [df stringFromDate:date];
        
        NSMutableString *tempDate = [[NSMutableString alloc]initWithString:dateString];
      
        int day1 = [[tempDate substringFromIndex:[tempDate length]-2] intValue];
        
        NSString *Sup;
        
        switch (day1) {
            case 1:
            case 21:
            case 31:
               // [tempDate appendString:@"st"];
                Sup =@"st";
                break;
            case 2:
            case 22:
               // [tempDate appendString:@"nd"];
                Sup =@"nd";
                break;
            case 3:
            case 23:
              //  [tempDate appendString:@"rd"];
                Sup =@"rd";
                break;
            default:
               // [tempDate appendString:@"th"];
                Sup =@"th";
                break;
        }
        
        NSString * str =[NSString stringWithFormat:@"<html><body><font face='Lato' size=3.5 color='#FFFFFF'>%@</font><font face='Lato' size=3 color='#FFFFFF'><sup>%@</sup></font><font face='lato' size=3.5 color='#FFFFFF'>%@</font></body></html>",tempDate,Sup,MonthStr];
        
        NSAttributedString * attStr= [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:true]options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        Listcell.EventDateDay.attributedText =attStr;
    }
    else
    {
        Listcell.EventDateDay.text = @"";
    }
    
    
    //Jignesh New Code
 
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_date"]]]==true)
    {
        //No need to show dates in cell
        //show grey background in date
        [Listcell.TicketBgImageView setImage:[UIImage imageNamed:@"cornergrey"]];
    }
    else
    {
        //Compaire date with today date to set background color in cell
        
        NSDateFormatter *NewTodayDateFormatter=[[NSDateFormatter alloc] init];
        
        [NewTodayDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        
        [NewTodayDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSDate *FinalStartDate=[NewTodayDateFormatter dateFromString:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_date"]]];
        ///----------------------------
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        NSTimeZone *gmt12 = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];

        [dateFormat setTimeZone:gmt12];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *TodayConvertedDate = [dateFormat dateFromString:timeStamp];
        
        NSLog(@"TodayConvertedDate::- %@",TodayConvertedDate);
        
        if ([TodayConvertedDate compare:FinalStartDate] != NSOrderedAscending)
        {
            //Show close or grey color
            [Listcell.TicketBgImageView setImage:[UIImage imageNamed:@"cornergrey"]];
        }
        else
        {
            [Listcell.TicketBgImageView setImage:[UIImage imageNamed:@"corner"]];
        }
        
    }
    
    ///----------------------------
    
    //Year
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_date"]]]==false)
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
        
         NSDate *yeardate = [df dateFromString:[NSString stringWithFormat:@"%@",[[TicketHistoryListArr objectAtIndex:indexPath.row]valueForKey:@"event_date"]]];
        [df setDateFormat:@"YYYY"];
        NSString *yearStr = [[df stringFromDate:yeardate] uppercaseString];
        
        Listcell.EventDateYear.text = [NSString stringWithFormat:@"%@",yearStr];
    }
    else
    {
        Listcell.EventDateYear.text = @"";
    }
    
    return Listcell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBBuyedTicketDetailViewController * TicketDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CBBuyedTicketDetailViewController"];
    TicketDetailViewController.TicketDetailDict = [TicketHistoryListArr objectAtIndex:indexPath.row];
    
    NSLog(@"%@",TicketDetailViewController.TicketDetailDict);
    
    [self.navigationController pushViewController:TicketDetailViewController animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - webservice call for  get ticket history

-(void) getMyTicketHistoryWebserviceCall
{
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        SHOW_NETWORK_ERROR_ALERT();
        return;
    } else {
        
        WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
        inputParam.webserviceRelativePath = @"ticketHistory.php";
        inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
        inputParam.dictPostParameters = [@{@"user_id" : [NSString stringWithFormat:@"%@",[USUserInfoModel sharedInstance].user_id] } mutableCopy];
        
        [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
            NSLog(@"response==>%@",response);
            
            if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"])
            {
                HIDE_LOADING();
                 [refreshControl endRefreshing];
                TicketHistoryListArr = [NSMutableArray new];
                TicketHistoryListArr = [[response valueForKey:@"body"] mutableCopy];
                
                [TicketHistoryListTable reloadData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    HIDE_LOADING();
                    
                });
                
            } else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    HIDE_LOADING();
                     [refreshControl endRefreshing];
                    
                });
            }
            
        } error:^(id response, NSError *error)
        {
            NSLog(@"%@",error.userInfo);
        }];
    }
}

-(NSString*)ordinalNumberFormat:(NSNumber *)numObj {
    NSString *ending;
    NSInteger num = [numObj integerValue];
    
    int ones = num % 10;
    int tens = floor(num / 10);
    tens = tens % 10;
    
    if(tens == 1){
        ending = @"th";
    } else {
        switch (ones)
        {
            case 1:
                ending = @"st";
                break;
            case 2:
                ending = @"nd";
                break;
            case 3:
                ending = @"rd";
                break;
            default:
                ending = @"th";
                break;
        }
    }
    
    return [NSString stringWithFormat:@"%d%@", num, ending];
}

#pragma mark - menu button click
- (IBAction)buttonMenuClicked:(UIButton *)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}
@end
