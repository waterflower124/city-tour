//
//  CBHomeDetailsViewController.m
//  CityBud
//
//  Created by Ajay Chaudhary on 29/01/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBHomeDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "CBMapDirectionViewController.h"
#import "KASlideShow.h"

#import <UberRides/UberRides-Swift.h>

#import <CoreLocation/CoreLocation.h>
#import "LocationTracker.h"

#import "PayStackPayController.h"

#import <PassKit/PassKit.h>
#import <Intents/Intents.h>
#import <IntentsUI/IntentsUI.h>

#import "CBGetTicketViewController.h"
#import "STMethod.h"


#import "PayStackPayController.h"


@interface CBHomeDetailsViewController ()
{
    double mylatitude, mylongitude;
    EKEventStore *store;
    EKEvent *event;
}

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation CBHomeDetailsViewController{
    
    NSMutableArray *datasource;
    NSUInteger showIndexOnLabel;
    
    NSString *destinationAdd;
    NSMutableArray *calendarArray;
}

@synthesize pageControl,hightviewforiphon4;

-(BOOL)substring:(NSString *)substr existsInString:(NSString *)str {
    if(!([str rangeOfString:substr options:NSCaseInsensitiveSearch].length==0)) {
        return YES;
    }
    
    return NO;
}


- (NSDate *)todaysDateFromString:(NSString *)time
{
    // Split hour/minute into separate strings:
    NSArray *array = [time componentsSeparatedByString:@":"];
    
    // Get year/month/day from today:
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    
    // Set hour/minute from the given input:
    [comp setHour:[array[0] integerValue]];
    [comp setMinute:[array[1] integerValue]];

    return [cal dateFromComponents:comp];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    labelTimeHeightConstraint.constant = 0;
    labelDateHeightConstraint.constant = 0;
    buttonShare.hidden=false;
    
    //    [self getAllCalendars];
    constraintViewHeaderHeight.constant = 0;
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height == 480)
    {
        // iPhone Classic
        hightviewforiphon4.constant = 150;
        
    }
    else if(result.height == 568)
    {
        // iPhone 5
        hightviewforiphon4.constant = 150;
        
    }else{
        
        hightviewforiphon4.constant = 365;
    }
    
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    backButton.clipsToBounds = YES;
//    [backButton sizeToFit];
//    backButton.center = CGPointMake(15,35);
//    [backButton setFrame:CGRectMake(10, 35, 40, 40)];
//    [backButton setTintColor:[UIColor darkGrayColor]];
//    [backButton setAlpha:1.0];
//
//    backButton.layer.cornerRadius = 4;
//    [backButton setImage:[UIImage imageNamed:@"back_button_theme_color"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(buttonBackClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//    [viewSlideShow addSubview:backButton];

    if(_showUberView == YES){
        
        [viewUber setHidden:NO];
        
    }else{
        [viewUber setHidden:YES];
        //constraintViewHeaderHeight.constant = 92;
    }
    
    if(_isFromSearch) {
        
        if (_showUberView){
            
            labelEventName2.text = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_name"]];
            
            labelEventVenue2.text = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_address"]];
            
            
            NSString *servicenameStr = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"servicename"]];
            
            if ([servicenameStr isEqualToString:@"movie"]) {
                
                NSString *target1=[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_description"]];
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<div>" withString: @""];
                target1 = [target1 stringByReplacingOccurrencesOfString: @"</div>" withString: @""];
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<b>" withString: @""];
                target1 = [target1 stringByReplacingOccurrencesOfString: @"</b>" withString: @""];
                
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<br>" withString: @""];
                
                // First text attributes
                
                NSRange redTextRange = [target1 rangeOfString:target1];
                
                
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:target1];
                
                [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14]} range:redTextRange];
                
                //Set the attributedText property of TTAttributedLabel
                
                labelWorkingHours.attributedText = attrString;
                
                
            }else if ([servicenameStr isEqualToString:@"religious"]){
                
                NSString *target1=[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_description"]];
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<div>" withString: @""];
                target1 = [target1 stringByReplacingOccurrencesOfString: @"</div>" withString: @""];
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<b>" withString: @""];
                target1 = [target1 stringByReplacingOccurrencesOfString: @"</b>" withString: @""];
                
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<br>" withString: @""];
                
                // First text attributes
                
                NSRange redTextRange = [target1 rangeOfString:target1];
                
                
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:target1];
                
                [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14]} range:redTextRange];
                
                //Set the attributedText property of TTAttributedLabel
                
                labelWorkingHours.attributedText = attrString;
                
            }else
            {
                //Jignesh Code for search result
                
                //To Get Previous Day
                
                NSDate *TodayDate = [NSDate date];
                
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *components = [[NSDateComponents alloc] init];
                
                components.day = -1;
                
                NSDate *PreviousnewDate = [calendar dateByAddingComponents:components toDate:TodayDate options:0];
                
                //To get previous day from date
                NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
                
                [weekday setDateFormat: @"EEEE"];
                
                NSString *PreviousdayName =  [weekday stringFromDate:PreviousnewDate];
                
                NSString *TodayDayName =  [weekday stringFromDate:[NSDate date]];
                
                if ([TodayDayName isEqualToString:@"Monday"]==true)
                {
                    PreviousdayName=@"LastSunday";
                }
                
                NSString *PDopeningTime = [NSString stringWithFormat:@"%@",[self.dictEventInfo2[@"weekly_timing"] valueForKey:[NSString stringWithFormat:@"%@",PreviousdayName]]];
                
                /*
                 "timings": {
                 "LastSunday": "2018-07-22 17:00 - 2018-07-23 05:00",
                 "Monday": "2018-07-23 03:00 - 2018-07-24 02:00",
                 "Tuesday": "2018-07-24 04:00 - 2018-07-25 03:00",
                 "Wednesday": "2018-07-25 17:00 - 2018-07-26 05:00",
                 "Thursday": "2018-07-26 17:00 - 2018-07-27 05:00",
                 "Friday": "2018-07-27 17:00 - 2018-07-28 05:00",
                 "Saturday": "2018-07-28 17:00 - 2018-07-29 05:00",
                 "Sunday": "2018-07-29 17:00 - 2018-07-30 05:00"
                 }
                 */
                
                if ([PDopeningTime isEqualToString:@"Closed"]) {
                    NSDate *now = [NSDate date];
                    
                    NSString *dayName =  [weekday stringFromDate:now];
                    
                    NSLog(@"%@",self.dictEventInfo2);
                    [self setOpeningTimeLblInWeekForOpeningDay:dayName OpeningTime:[NSString stringWithFormat:@"%@",[self.dictEventInfo2[@"weekly_timing"] valueForKey:[NSString stringWithFormat:@"%@",dayName]]]];
                }  else  {
                    
                    NSDateFormatter *PreviousDateFormate = [[NSDateFormatter alloc] init];
                    
                    [PreviousDateFormate setDateFormat: @"yyyy-MM-dd"];
                    
                    NSString *PDTempStr=[PreviousDateFormate stringFromDate:PreviousnewDate];
                    
                    NSArray *listItems = [PDopeningTime componentsSeparatedByString:@"-"];
                    
                    NSString *strCloseTime = @"";
                    
                    if (listItems.count > 1) {
                        strCloseTime = [NSString stringWithFormat:@"%@",[listItems objectAtIndex:1]];
                    }
                    
                    
                    PDTempStr = [NSString stringWithFormat:@"%@ %@", PDTempStr, strCloseTime];
                    
                    
                    NSDateFormatter *NewPreDateFormatter=[[NSDateFormatter alloc] init];
                    
                    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT+1"];
                    
                    [NewPreDateFormatter setTimeZone:gmt];
                    
                    [NewPreDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    
                    NSDate *PDToCompaire=[NewPreDateFormatter dateFromString:PDTempStr];
                    
                    NSLog(@"PDTempStr :: %@",PDTempStr);
                    
                    NSLog(@"PDToCompaire :: %@",PDToCompaire);
                    
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    NSTimeZone *gmt12 = [NSTimeZone timeZoneWithAbbreviation:@"GMT+1"];
                    [dateFormat setTimeZone:gmt12];
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSDate *TodayConvertedDate = [dateFormat dateFromString:timeStamp];
                    
                    
                    if ([TodayConvertedDate compare:PDToCompaire] != NSOrderedDescending)
                    {
                        // now should be inside = Open
                        //From Previous Day
                        NSLog(@"%@",self.dictEventInfo2);
                        
                        [self setOpeningTimeLblInWeekForOpeningDay:PreviousdayName OpeningTime:[NSString stringWithFormat:@"%@",[self.dictEventInfo2[@"weekly_timing"] valueForKey:[NSString stringWithFormat:@"%@",PreviousdayName]]]];
                        
                    }
                    else
                    {
                        //For today day and date
                        NSDate *now = [NSDate date];
                        
                        NSString *dayName =  [weekday stringFromDate:now];
                        
                        NSLog(@"%@",self.dictEventInfo2);
                        
                        [self setOpeningTimeLblInWeekForOpeningDay:dayName OpeningTime:[NSString stringWithFormat:@"%@",[self.dictEventInfo2[@"weekly_timing"] valueForKey:[NSString stringWithFormat:@"%@",dayName]]]];
                        
                    }
                    
                }
                
            }
            
            NSString *newString = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"phone"]];
            newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if ([STMethod stringIsEmptyOrNot:newString] == false) {
                
                [buttonPhoneNumber2 setTitle:newString forState:UIControlStateNormal];
                
            }else{
                
                [buttonPhoneNumber2 setTitle:@"      " forState:UIControlStateNormal];
            }
            
            
            
            NSString *SiteURL = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"siteurl"]];
            
            if ([STMethod stringIsEmptyOrNot:SiteURL] == false) {
                
                SiteURL=[SiteURL stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
                
                
                if ([SiteURL.lowercaseString hasPrefix:@"http://"] || [SiteURL.lowercaseString hasPrefix:@"https://"])
                {
                    candidateURL = [[NSURL alloc]initWithString:[SiteURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                }
                else
                {
                    
                    candidateURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
                    
                }
                
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
                {
                    [buttonWebsite2 setTitle:[NSString stringWithFormat:@"%@",candidateURL] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [buttonWebsite2 setTitle:@"http://citybudng.com/" forState:UIControlStateNormal];
                }
                
            }else{
                [buttonWebsite2 setTitle:@"http://citybudng.com/" forState:UIControlStateNormal];
            }
        }
        
        
        labelCityName.text =  self.cityName;
        
        labelEventName.text = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_name"]];
        
        // event_name | event_venue - event_address, event_city
        NSString * eventName;

        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",_dictEventInfo2[@"event_name"]]]==false)
        {
            eventName = [NSString stringWithFormat:@"%@",_dictEventInfo2[@"event_name"]];
        }
        else
        {
            eventName = @" ";
        }
        
        NSString * eventVenue;
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",_dictEventInfo2[@"event_venue"]]]==false)
        {
            eventVenue = [NSString stringWithFormat:@"%@",_dictEventInfo2[@"event_venue"]];
        }
        else
        {
            eventVenue = @" ";
        }
        
        NSString * eventAddress;
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",_dictEventInfo2[@"event_address"]]]==false)
        {
            eventAddress = [NSString stringWithFormat:@"%@",_dictEventInfo2[@"event_address"]];
        }
        else
        {
            eventAddress = @" ";
        }
        
        NSString * eventCity;
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",_dictEventInfo2[@"event_city"]]]==false)
        {
            eventCity = [NSString stringWithFormat:@"%@",_dictEventInfo2[@"event_city"]];
        }
        else
        {
            eventCity = @" ";
        }
        
        labelEventAddress.text = [NSString stringWithFormat:@"%@ | %@",eventName,eventVenue];
        
        NSString *newString = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"phone"]];
        newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ([STMethod stringIsEmptyOrNot:newString] == false) {
            
            [buttonPhoneNumber setTitle:newString forState:UIControlStateNormal];
            
        }else{
            
            [buttonPhoneNumber setTitle:@"      " forState:UIControlStateNormal];
        }
        
        
        NSString *SiteURL = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"siteurl"]];
        
        if ([STMethod stringIsEmptyOrNot:SiteURL] == false) {
            
            SiteURL=[SiteURL stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
            
            
            if ([SiteURL.lowercaseString hasPrefix:@"http://"] || [SiteURL.lowercaseString hasPrefix:@"https://"])
            {
                candidateURL = [[NSURL alloc]initWithString:[SiteURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            }
            else
            {
                
                candidateURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
                
            }
            
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                [buttonWebsite setTitle:[NSString stringWithFormat:@"%@",candidateURL] forState:UIControlStateNormal];
                
            }
            else
            {
                [buttonWebsite setTitle:@"http://citybudng.com/" forState:UIControlStateNormal];
            }
            
        }else{
            [buttonWebsite setTitle:@"http://citybudng.com/" forState:UIControlStateNormal];
        }
        
       
        
        if ([_eventType isEqualToString:@"Restaurants"] || [_eventType isEqualToString:@"Banks & ATMs"] || [_eventType isEqualToString:@"Health & Wellness"] ){
            
            labelEventDate.text = @"Date";
            labelEventTime.text = @"Hours of operation";
            
            NSString * datestr2,*timestr2;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_date"]]]==false)
            {
                datestr2 = [NSString stringWithFormat:@"%@",[self getDateFromDateDtring:self.dictEventInfo2[@"event_date"]]];
            }
            else
            {
                datestr2 = @" ";
            }
            
            labelDate.text = datestr2;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_time"]]]==false)
            {
                timestr2 = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_time"]];
            }
            else
            {
                timestr2 = @" ";
            }
            
            labelTime.text= timestr2;
            
        }else if ([_eventType isEqualToString:@"Movies"]){
            
            labelEventDate.text = @"Movie Date";
            labelEventTime.text = @"Movie Time";
            
            NSString * datestr3,*timestr3;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_date"]]]==false)
            {
                datestr3 = [NSString stringWithFormat:@"%@",[self getDateFromDateDtring:self.dictEventInfo2[@"event_date"]]];
            }
            else
            {
                datestr3 = @" ";
            }
            
            labelDate.text = datestr3;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_time"]]]==false)
            {
                timestr3 = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_time"]];
            }
            else
            {
                timestr3 = @" ";
            }
            
            labelTime.text= timestr3;
            
        }else if ([_eventType isEqualToString:@"Featured Venues"])
        {
            
            labelEventDate.text = @"Venue Date";
            labelEventTime.text = @"Venue Time";
            
            NSString * datestr4,*timestr4;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_date"]]]==false)
            {
                datestr4 = [NSString stringWithFormat:@"%@",[self getDateFromDateDtring:self.dictEventInfo2[@"event_date"]]];
            }
            else
            {
                datestr4 = @" ";
            }
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_time"]]]==false)
            {
                timestr4 = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_time"]];
            }
            else
            {
                timestr4 = @" ";
            }
            
            labelDate.text = datestr4;
            labelTime.text= timestr4;
            
        }else{
            labelEventDate.text = @"Event Date";
            labelEventTime.text = @"Event Time";
            
            NSString * eventDate;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_date"]]]==false)
            {
                eventDate = [NSString stringWithFormat:@"%@",[self getDateFromDateDtring:self.dictEventInfo2[@"event_date"]]];
            }
            else
            {
                eventDate = @" ";
            }
            
            NSString *sDate;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_time"]]]==false)
            {
                sDate = [NSString stringWithFormat:@"%@",[self getTimeFromTimeString:self.dictEventInfo2[@"event_time"]]];
            }
            else
            {
                sDate =@" ";
            }
            
            NSString *eDate;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_endtime"]]]==false)
            {
                eDate = [NSString stringWithFormat:@"%@",[self getTimeFromTimeString:self.dictEventInfo2[@"event_endtime"]]];
            }
            else
            {
                eDate = @" ";
            }
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[[NSString stringWithFormat:@"%@ %@ %@ - %@",eventCity,eventDate,sDate,eDate] uppercaseString]];
            
            float spacing = 1.0f;
            [attributedString addAttribute:NSKernAttributeName
                                     value:@(spacing)
                                     range:NSMakeRange(0, [[NSString stringWithFormat:@"%@ %@ - %@",eventDate,sDate,eDate] length])];
            
            
            labelDate.attributedText = attributedString;
            
//            if ([[NSString stringWithFormat:@"%@",APPDELEGATE.attendingPeople] isEqualToString:@"no"])
//            {
                if ([STMethod  stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",_dictEventInfo2[@"peoples_attending"]]] ==false)
                {
                    [peopleAttendingBtn setTitle:[NSString stringWithFormat:@"%@ people are attending",_dictEventInfo2[@"peoples_attending"]] forState:UIControlStateNormal];
                }
                else
                {
                    [peopleAttendingBtn setTitle:@"0 people are attending" forState:UIControlStateNormal];
                }

                
          //  }
//            else
//            {
//                if ([STMethod  stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",APPDELEGATE.attendingPeople]] ==false)
//                {
//                    [peopleAttendingBtn setTitle:[NSString stringWithFormat:@"%@ people are attending",APPDELEGATE.attendingPeople] forState:UIControlStateNormal];
//                }
//                else
//                {
//                    [peopleAttendingBtn setTitle:@"0 people are attending" forState:UIControlStateNormal];
//                }
//            }
        }
        
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_description"]]]==true)
        {
            labelEventDiscription.text = @" ";
        }
        else
        {
            labelEventDiscription.text = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_description"]];
        }
        
        
        NSString *stringName = @"Opening & Closing Time";
        
        NSString *target1=[NSString stringWithFormat:@"%@",labelEventDiscription.text];
        
        
        if([self substring:stringName existsInString:target1]) {
            
            NSLog(@"It exists!");
            
            labelEventDiscription.text = [labelEventDiscription.text stringByReplacingOccurrencesOfString: @"<b>" withString: @""];
            labelEventDiscription.text = [labelEventDiscription.text stringByReplacingOccurrencesOfString: @"</b>" withString: @""];
            
            NSString *target=[NSString stringWithFormat:@"%@",labelEventDiscription.text];
            target = [labelEventDiscription.text stringByReplacingOccurrencesOfString: @"<br>" withString: @""];
            
            // First text attributes
            NSRange redTextRange = [target rangeOfString:stringName];
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:target];

            [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato-Bold" size:14]} range:redTextRange];
        
            //Set the attributedText property of TTAttributedLabel
            
            labelEventDiscription.attributedText = attrString;
            labelEventDiscription12.attributedText = attrString;
        }
        else {
            NSLog(@"It does not exist!");
            labelEventDiscription.text = [labelEventDiscription.text stringByReplacingOccurrencesOfString: @"<b>" withString: @""];
            
            labelEventDiscription.text = [labelEventDiscription.text stringByReplacingOccurrencesOfString: @"</b>" withString: @""];
            
            labelEventDiscription.text = [labelEventDiscription.text stringByReplacingOccurrencesOfString: @"<br>" withString: @""];
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_description"]]]==true)
            {
                labelEventDiscription.text = @" ";
                labelEventDiscription12.text = @" ";
            }
            else
            {
                labelEventDiscription.text = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_description"]];
                labelEventDiscription12.text = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_description"]];
            }
        }
        
        NSArray *arrimages  = self.dictEventInfo[@"images"];
        
        if (arrimages.count == 0) {
            
            NSArray *arrSearchEventPic = [self.dictEventInfo[@"event_pic"] componentsSeparatedByString:@","];
            NSMutableArray *img=[NSMutableArray new];
            NSMutableArray *arrImg = [NSMutableArray new];
            
            for (img in arrSearchEventPic) {
                NSLog(@"dictEventInfo slider image link is %@",img);
                [arrImg addObject:[NSString stringWithFormat:@"%@",img]];
                datasource = [arrImg mutableCopy];
            }
            
        }else{
            
            NSMutableArray *arrImg = [NSMutableArray new];
            for (int i=0; i<arrimages.count; i++) {
                
                NSString *imageurlstr = [[self.dictEventInfo[@"images"] objectAtIndex:i] valueForKey:@"event_image"];
                [arrImg addObject:[NSString stringWithFormat:@"%@",imageurlstr]];
                datasource = [arrImg mutableCopy];
            }
        }
        
//        NSArray *arrSearchEventPic = [self.dictEventInfo2[@"event_pic"] componentsSeparatedByString:@","];
//        NSMutableArray *img=[NSMutableArray new];
//        NSMutableArray *arrImg = [NSMutableArray new];
//
//        for (img in arrSearchEventPic) {
//            NSLog(@"dictEventInfo2 slider image link is %@",img);
//            [arrImg addObject:[NSString stringWithFormat:@"%@",img]];
//            datasource = [arrImg mutableCopy];
//        }
    }else{
        
        if (_showUberView) {
            
            labelEventName2.text =[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_name"]];
            labelEventVenue2.text = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_address"]];
            
            NSString *servicenameStr = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"servicename"]];
            
            if ([servicenameStr isEqualToString:@"movie"]) {
               
                NSString *target1=[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_description"]];
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<div>" withString: @""];
                target1 = [target1 stringByReplacingOccurrencesOfString: @"</div>" withString: @""];
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<b>" withString: @""];
                target1 = [target1 stringByReplacingOccurrencesOfString: @"</b>" withString: @""];
                
               
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<br>" withString: @""];
                
                // First text attributes
                
                NSRange redTextRange = [target1 rangeOfString:target1];
                
                
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:target1];
                
                [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14]} range:redTextRange];
                
                //Set the attributedText property of TTAttributedLabel
                
                labelWorkingHours.attributedText = attrString;
                
                
            }else if ([servicenameStr isEqualToString:@"religious"]){
                
                NSString *target1=[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_description"]];
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<div>" withString: @""];
                target1 = [target1 stringByReplacingOccurrencesOfString: @"</div>" withString: @""];
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<b>" withString: @""];
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"</b>" withString: @""];
                
                target1 = [target1 stringByReplacingOccurrencesOfString: @"<br>" withString: @""];
                
                // First text attributes
                
                NSRange redTextRange = [target1 rangeOfString:target1];
                
                
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:target1];
                
                [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato" size:14]} range:redTextRange];
                
                //Set the attributedText property of TTAttributedLabel
                labelWorkingHours.attributedText = attrString;
                
            } else {
                //Jignesh Code
                
                //To Get Previous Day
                
                NSDate *TodayDate = [NSDate date];
                
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *components = [[NSDateComponents alloc] init];
                components.day = -1;
                
                NSDate *PreviousnewDate = [calendar dateByAddingComponents:components toDate:TodayDate options:0];
                
                //To get previous day from date
                NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
                [weekday setDateFormat: @"EEEE"];
                [weekday setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+1"]];
                
                NSString *PreviousdayName =  [weekday stringFromDate:PreviousnewDate];
                
                NSString *PDopeningTime = [NSString stringWithFormat:@"%@",[self.dictEventInfo[@"weekly_timing"] valueForKey:[NSString stringWithFormat:@"%@",PreviousdayName]]];
                                
                if ([PDopeningTime isEqualToString:@"Closed"]) {
                    NSDate *now = [NSDate date];
                    
                    NSString *dayName =  [weekday stringFromDate:now];
                    
                    NSLog(@"%@",self.dictEventInfo);
                    [self setOpeningTimeLblInWeekForOpeningDay:dayName OpeningTime:[NSString stringWithFormat:@"%@",[self.dictEventInfo[@"weekly_timing"] valueForKey:[NSString stringWithFormat:@"%@",dayName]]]];
                    
                } else {
                    
                    NSDateFormatter *PreviousDateFormate = [[NSDateFormatter alloc] init];
                    
                    [PreviousDateFormate setDateFormat: @"yyyy-MM-dd"];
                    
                    NSString *PDTempStr=[PreviousDateFormate stringFromDate:PreviousnewDate];
                    
                    NSArray *listItems = [PDopeningTime componentsSeparatedByString:@"-"];

                    NSString *strCloseTime = @"";
                    if (listItems.count > 1) {
                        strCloseTime = [NSString stringWithFormat:@"%@",[listItems objectAtIndex:1]];
                    }
                    
                    PDTempStr = [NSString stringWithFormat:@"%@ %@", PDTempStr, strCloseTime];
                    
                    NSDateFormatter *NewPreDateFormatter=[[NSDateFormatter alloc] init];
                    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT+1"];
                    [NewPreDateFormatter setTimeZone:gmt];
                    [NewPreDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    
                    NSDate *PDToCompaire=[NewPreDateFormatter dateFromString:PDTempStr];
                    
                    if ([TodayDate compare:PDToCompaire] != NSOrderedDescending) {
                        // now should be inside = Open
                        //From Previous Day
                        NSLog(@"%@",self.dictEventInfo);
                        
                        [self setOpeningTimeLblInWeekForOpeningDay:PreviousdayName OpeningTime:[NSString stringWithFormat:@"%@",[self.dictEventInfo[@"weekly_timing"] valueForKey:[NSString stringWithFormat:@"%@",PreviousdayName]]]];
                        
                    } else {
                        //For today day and date
                        NSDate *now = [NSDate date];
                        
                        NSString *dayName =  [weekday stringFromDate:now];
                        
                        NSLog(@"%@",self.dictEventInfo);
                        
                          [self setOpeningTimeLblInWeekForOpeningDay:dayName OpeningTime:[NSString stringWithFormat:@"%@",[self.dictEventInfo[@"weekly_timing"] valueForKey:[NSString stringWithFormat:@"%@",dayName]]]];
                        
                    }
                    
                }
              
            }
            
            
            NSString *newString = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"phone"]];
            
            newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if ([STMethod stringIsEmptyOrNot:newString] == false)
            {
                
                [buttonPhoneNumber2 setTitle:newString forState:UIControlStateNormal];
                
            }else{
                
                [buttonPhoneNumber2 setTitle:@"      " forState:UIControlStateNormal];
            }

            
            NSString *SiteURL = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"siteurl"]];
            
            if ([STMethod stringIsEmptyOrNot:SiteURL] == false) {
                
                SiteURL=[SiteURL stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
                
                
                if ([SiteURL.lowercaseString hasPrefix:@"http://"] || [SiteURL.lowercaseString hasPrefix:@"https://"])
                {
                    candidateURL = [[NSURL alloc]initWithString:[SiteURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                }
                else
                {
                    
                    candidateURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
                }
                
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
                {
                    [buttonWebsite2 setTitle:[NSString stringWithFormat:@"%@",candidateURL] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [buttonWebsite2 setTitle:@"http://citybudng.com/" forState:UIControlStateNormal];
                }
                
            }else{
                [buttonWebsite2 setTitle:@"http://citybudng.com/" forState:UIControlStateNormal];
            }
            
        }
        
        labelCityName.text = self.cityName;
        labelEventName.text = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_name"]];
        
        // event_name | event_venue - event_address, event_city
        NSString * eventName;
        
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",_dictEventInfo[@"event_name"]]]==false)
        {
            eventName = [NSString stringWithFormat:@"%@",_dictEventInfo[@"event_name"]];
        }
        else
        {
            eventName = @" ";
        }
        
        NSString * eventVenue;
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",_dictEventInfo[@"event_venue"]]]==false)
        {
            eventVenue = [NSString stringWithFormat:@"%@",_dictEventInfo[@"event_venue"]];
        }
        else
        {
            eventVenue = @" ";
        }
        
        NSString * eventAddress;
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",_dictEventInfo[@"event_address"]]]==false)
        {
            eventAddress = [NSString stringWithFormat:@"%@",_dictEventInfo[@"event_address"]];
        }
        else
        {
            eventAddress = @" ";
        }
        
        NSString * eventCity;
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",_dictEventInfo[@"event_city"]]]==false)
        {
            eventCity = [NSString stringWithFormat:@"%@",_dictEventInfo[@"event_city"]];
        }
        else
        {
            eventCity = @" ";
        }
        
        labelEventAddress.text = [NSString stringWithFormat:@"%@ | %@",eventName,eventVenue];
        
        
        
//        if ([[NSString stringWithFormat:@"%@",APPDELEGATE.attendingPeople] isEqualToString:@"no"])
//        {
            if ([STMethod  stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",_dictEventInfo[@"peoples_attending"]]] ==false)
            {
                [peopleAttendingBtn setTitle:[NSString stringWithFormat:@"%@ people are attending",_dictEventInfo[@"peoples_attending"]] forState:UIControlStateNormal];
            }
            else
            {
                [peopleAttendingBtn setTitle:@"0 people are attending" forState:UIControlStateNormal];
            }
//        }
//        else
//        {
//            if ([STMethod  stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",APPDELEGATE.attendingPeople]] ==false)
//            {
//                [peopleAttendingBtn setTitle:[NSString stringWithFormat:@"%@ people are attending",APPDELEGATE.attendingPeople] forState:UIControlStateNormal];
//            }
//            else
//            {
//                [peopleAttendingBtn setTitle:@"0 people are attending" forState:UIControlStateNormal];
//            }
//
//        }
        
        NSString *newString = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"phone"]];
        
        newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ([STMethod stringIsEmptyOrNot:newString] == false) {
            
            [buttonPhoneNumber setTitle:newString forState:UIControlStateNormal];
            
        }else{
            
            [buttonPhoneNumber setTitle:@"      " forState:UIControlStateNormal];
        }
        
       // [buttonPhoneNumber setTitle: [self.dictEventInfo[@"phone"] isEqualToString:@""] ? @"0000000000" : self.dictEventInfo[@"phone"] forState:UIControlStateNormal];
        
        NSString *SiteURL = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"siteurl"]];
        
        if ([STMethod stringIsEmptyOrNot:SiteURL] == false) {
            
            SiteURL=[SiteURL stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
            
            
            if ([SiteURL.lowercaseString hasPrefix:@"http://"] || [SiteURL.lowercaseString hasPrefix:@"https://"])
            {
                candidateURL = [[NSURL alloc]initWithString:[SiteURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            }
            else
            {
                
                candidateURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
                
            }
            
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                [buttonWebsite setTitle:[NSString stringWithFormat:@"%@",candidateURL] forState:UIControlStateNormal];
                
            }
            else
            {
                [buttonWebsite setTitle:@"http://citybudng.com/" forState:UIControlStateNormal];
            }
            
        }else{
            [buttonWebsite setTitle:@"http://citybudng.com/" forState:UIControlStateNormal];
        }
        
        //            Restaurants
        //            Banks & ATMs
        //            Movies
        //            Featured Venues
        //            Health & Wellness
        
        if ([_eventType isEqualToString:@"Restaurants"] || [_eventType isEqualToString:@"Banks & ATMs"] || [_eventType isEqualToString:@"Health & Wellness"] ){
            
            labelEventDate.text = @"Date";
            labelEventTime.text = @"Hours of operation";
            
            NSString *labelDatestr;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_date"]]]==false)
            {
                labelDatestr = [NSString stringWithFormat:@"%@",[self getDateFromDateDtring:self.dictEventInfo[@"event_date"]]];
            }
            else
            {
                labelDatestr = @" ";
            }
            
            labelDate.text = labelDatestr;
            labelTime.text= [NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_time"]];
            
        }
        
        else if ([_eventType isEqualToString:@"religious"]){
            
            labelEventDate.text = @"religious Date";
            labelEventTime.text = @"religious Time";
            
            NSString *labelDatestr;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_date"]]]==false)
            {
                labelDatestr = [NSString stringWithFormat:@"%@",[self getDateFromDateDtring:self.dictEventInfo[@"event_date"]]];
            }
            else
            {
                labelDatestr = @" ";
            }
            
            labelDate.text = labelDatestr;
            
            NSString *labelTime1;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_time"]]]]==false)
            {
                labelTime1 = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_time"]]];
            }
            else
            {
                labelTime1 = @" ";
            }
            
            labelTime.text= labelTime1;
            
            
        }
        
        else if ([_eventType isEqualToString:@"Movies"]){
            
            labelEventDate.text = @"Movie Date";
            labelEventTime.text = @"Movie Time";
            
            NSString *labelDatestr;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_date"]]]==false)
            {
                labelDatestr = [NSString stringWithFormat:@"%@",[self getDateFromDateDtring:self.dictEventInfo[@"event_date"]]];
            }
            else
            {
                labelDatestr = @" ";
            }
            
            labelDate.text = labelDatestr;
        
            NSString *labelTime1;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_time"]]]]==false)
            {
                labelTime1 = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_time"]]];
            }
            else
            {
                labelTime1 = @" ";
            }
            
            labelTime.text= labelTime1;
        }
        
        else if ([_eventType isEqualToString:@"Featured Venues"]){
            
            labelEventDate.text = @"Venue Date";
            labelEventTime.text = @"Venue Time";
            
            NSString *labelEventDatestr,*labelEventTimestr;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_date"]]]==false)
            {
                labelEventDatestr = [NSString stringWithFormat:@"%@",[self getDateFromDateDtring:self.dictEventInfo[@"event_date"]]];
            }
            else
            {
                labelEventDatestr = @" ";
            }
            
            labelDate.text = labelEventDatestr;
            
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_time"]]]]==false)
            {
                labelEventTimestr = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_time"]]];
            }
            else
            {
                labelEventTimestr = @" ";
            }
            
            labelTime.text= labelEventTimestr;
            
        }else{
            labelEventDate.text = @"Event Date";
            labelEventTime.text = @"Event Time";
            
            NSLog(@"%@",_dictEventInfo);
            
            // event_name | event_venue - event_address, event_city
        
            NSString * eventDate;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_date"]]]==false)
            {
                eventDate = [NSString stringWithFormat:@"%@",[self getDateFromDateDtring:self.dictEventInfo[@"event_date"]]];
            }
            else
            {
                eventDate = @" ";
            }
            
            NSString *sDate;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_time"]]]==false)
            {
                sDate = [NSString stringWithFormat:@"%@",[self getTimeFromTimeString:self.dictEventInfo[@"event_time"]]];
            }
            else
            {
                sDate =@" ";
            }
            
            NSString *eDate;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_endtime"]]]==false)
            {
                eDate = [NSString stringWithFormat:@"%@",[self getTimeFromTimeString:self.dictEventInfo[@"event_endtime"]]];
            }
            else
            {
                eDate = @" ";
            }
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[[NSString stringWithFormat:@"%@ %@ %@ - %@",eventCity,eventDate,sDate,eDate] uppercaseString]];
            
            float spacing = 1.0f;
            [attributedString addAttribute:NSKernAttributeName
                                     value:@(spacing)
                                     range:NSMakeRange(0, [[NSString stringWithFormat:@"%@ %@ %@ - %@",eventCity,eventDate,sDate,eDate] length])];
            
            labelDate.attributedText = attributedString;
        }
        
        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_description"]]]==true)
        {
            labelEventDiscription.text= @" ";
        }
        else
        {
            labelEventDiscription.text= [NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_description"]];
        }
        
        NSString *stringName = @"Opening & Closing Time";
        
        NSString *target1=[NSString stringWithFormat:@"%@",labelEventDiscription.text];
        
        
        if([self substring:stringName existsInString:target1]) {
            
            NSLog(@"It exists!");
            
            labelEventDiscription.text = [labelEventDiscription.text stringByReplacingOccurrencesOfString: @"<b>" withString: @""];
            labelEventDiscription.text = [labelEventDiscription.text stringByReplacingOccurrencesOfString: @"</b>" withString: @""];
            
            NSString *target=[NSString stringWithFormat:@"%@",labelEventDiscription.text];
            
            target = [labelEventDiscription.text stringByReplacingOccurrencesOfString: @"<br>" withString: @""];
            
            // First text attributes
            
            NSRange redTextRange = [target rangeOfString:stringName];
            
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:target];
            
            [attrString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Lato-Bold" size:14]} range:redTextRange];
            
            //Set the attributedText property of TTAttributedLabel
            
            labelEventDiscription.attributedText = attrString;
            labelEventDiscription12.attributedText = attrString;
        }
        else {
            NSLog(@"It does not exist!");
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_description"]]]==true)
            {
                labelEventDiscription.text = @" ";
                labelEventDiscription12.text = @" ";
            }
            else
            {
                
                labelEventDiscription.text = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_description"]];

                labelEventDiscription12.text = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_description"]];
            }
            
        }
        
        NSArray *arrimages  = self.dictEventInfo[@"images"];
        
        
        if (arrimages.count == 0) {
            
            NSArray *arrSearchEventPic = [self.dictEventInfo[@"event_pic"] componentsSeparatedByString:@","];
            NSMutableArray *img=[NSMutableArray new];
            NSMutableArray *arrImg = [NSMutableArray new];
            
            for (img in arrSearchEventPic) {
                NSLog(@"dictEventInfo slider image link is %@",img);
                [arrImg addObject:[NSString stringWithFormat:@"%@",img]];
                datasource = [arrImg mutableCopy];
            }
            
        }else{
        
             NSMutableArray *arrImg = [NSMutableArray new];
            for (int i=0; i<arrimages.count; i++) {
                
               NSString *imageurlstr = [[self.dictEventInfo[@"images"] objectAtIndex:i] valueForKey:@"event_image"];
               [arrImg addObject:[NSString stringWithFormat:@"%@",imageurlstr]];
                datasource = [arrImg mutableCopy];
            }
        }
    }
    
    pageControl.currentPage=0;
    pageControl.numberOfPages=[datasource count];
    
   // ImageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

#pragma mark - Set and show time for open close based on days
-(void)setOpeningTimeLblInWeekForOpeningDay:(NSString*)dayName OpeningTime:(NSString*)openingDateTimeStr
{
  
    NSLog(@"%@",self.dictEventInfo);
    
    if ([openingDateTimeStr isEqualToString:@"Closed"]) {
        NSString *strComplete = [NSString new];
        NSString *open = @"Closed";
        
        strComplete = [NSString stringWithFormat:@"( %@ opening times unavailable)  %@",dayName,open];
        
        NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:strComplete];
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor redColor]
                                 range:[strComplete rangeOfString:open]];
        labelWorkingHours.attributedText = attributedString;
    } else {
        
        NSArray *listItems = [openingDateTimeStr componentsSeparatedByString:@"-"];
       
        NSString *strOpenTime = @"";
        
        if (listItems.count > 1) {
            strOpenTime = [NSString stringWithFormat:@"%@",[listItems objectAtIndex:0]];
        }
        
        NSString *strCloseTime = @"";
        
        if (listItems.count > 1) {
            strCloseTime = [NSString stringWithFormat:@"%@",[listItems objectAtIndex:1]];
        }
        
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT+1"];
        NSDateFormatter *dateforamtter = [[NSDateFormatter alloc] init];
        [dateforamtter setDateFormat:@"HH:mm"];
        [dateforamtter setTimeZone:gmt];
        
        NSDate *startDate = [dateforamtter dateFromString:strOpenTime];
        NSDate *endDate = [dateforamtter dateFromString:strCloseTime];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+1"]];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
        NSDateComponents *startComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:startDate];
        NSDateComponents *endComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:endDate];
        
        components.weekday = [NSDate weekdayFromString:dayName];
        components.hour = startComponents.hour;
        components.minute = startComponents.minute;
        
        NSDate *finalStartDate = [calendar dateFromComponents:components];
        
        components.hour = endComponents.hour;
        components.minute = endComponents.minute;
        
        NSDate *finalEndDate = [calendar dateFromComponents:components];
        if ([startDate compare:endDate] != NSOrderedAscending) {
            finalEndDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:finalEndDate options:NSCalendarWrapComponents];
        }
        
        NSString * openingTime = [NSString stringWithFormat:@"%@ - %@",strOpenTime,strCloseTime];
        
       if ([[NSDate date] compare:finalStartDate] != NSOrderedAscending && [[NSDate date] compare:finalEndDate] != NSOrderedDescending) {
            NSLog(@"now should be inside = Open");
            
            NSString *strComplete = [NSString new];
            NSString *open = @"Open";
            
            
            if ([dayName isEqualToString:@"LastSunday"]==true) {
                dayName=@"Sunday";
            }
            
            strComplete = [NSString stringWithFormat:@"( %@ %@ )  %@",dayName,openingTime,open];
            
            NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:strComplete];
            
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor colorWithRed:0.02 green:0.29 blue:0.02 alpha:1.0]
                                     range:[strComplete rangeOfString:open]];
            labelWorkingHours.attributedText = attributedString;
        } else {
            NSLog(@"now is outside = Close");
            
            NSString *strComplete = [NSString new];
            NSString *open = @"Closed";
            
            if ([dayName isEqualToString:@"LastSunday"]==true)
            {
                dayName=@"Sunday";
            }
            
            strComplete = [NSString stringWithFormat:@"( %@ %@ )  %@",dayName,openingTime,open];
            
            NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:strComplete];
            
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor redColor]
                                     range:[strComplete rangeOfString:open]];
            labelWorkingHours.attributedText = attributedString;
        }
    }
}

- (void)uberButton
{
    UBSDKRideRequestButton *button = [[UBSDKRideRequestButton alloc] init];
    
    //[button setTitle:@"Get Ride" forState:UIControlStateNormal];
    
    if(_showUberView == YES)
    {
        button.center = buttonUber2.center;
        //        button.frame = buttonUber2.bounds;
        button.clipsToBounds = YES;
        [button setFrame:buttonUber2.bounds];
        [buttonUber2 addSubview:button];
      
        
    }else{
        //button.center = buttonUber.center;
        button.frame = buttonUber.frame;
        button.clipsToBounds = YES;
        [button setFrame:buttonUber.bounds];
        [buttonUber addSubview:button];
        
//        button.translatesAutoresizingMaskIntoConstraints = NO;
//        /* Leading space to superview */
//        NSLayoutConstraint *leftButtonConstraint = [NSLayoutConstraint
//                                                    constraintWithItem:button attribute:NSLayoutAttributeLeading
//                                                    relatedBy:NSLayoutRelationEqual toItem:detailView attribute:
//                                                    NSLayoutAttributeLeading multiplier:1.0 constant:self.view.frame.size.width/2+8];
//        /* Top space to superview Y*/
//        /*
//         NSLayoutConstraint *topButtonConstraint = [NSLayoutConstraint
//         constraintWithItem:button attribute:NSLayoutAttributeTop
//         relatedBy:NSLayoutRelationEqual toItem:containerView attribute:
//         NSLayoutAttributeTop multiplier:1.0f constant:95]; */
//
//        /* Top space to superview Y*/
//        NSLayoutConstraint *bttomButtonConstraint = [NSLayoutConstraint
//                                                     constraintWithItem:button attribute:NSLayoutAttributeTop
//                                                     relatedBy:NSLayoutRelationEqual toItem:buttonUber attribute:
//                                                     NSLayoutAttributeTop multiplier:-1.0f constant:0];;
//
//        /* Top space to superview Y*/
//        NSLayoutConstraint *rightButtonYConstraint = [NSLayoutConstraint
//                                                      constraintWithItem:button attribute:NSLayoutAttributeTrailing
//                                                      relatedBy:NSLayoutRelationEqual toItem:detailView attribute:
//                                                      NSLayoutAttributeTrailing multiplier:1.0f constant:60];
//        /* Fixed width */
//        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:button
//                                                                           attribute:NSLayoutAttributeWidth
//                                                                           relatedBy:NSLayoutRelationEqual
//                                                                              toItem:nil
//                                                                           attribute:NSLayoutAttributeNotAnAttribute
//                                                                          multiplier:1.0
//                                                                            constant:self.view.frame.size.width/2-24];
//        /* Fixed Height */
//        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:button
//                                                                            attribute:NSLayoutAttributeHeight
//                                                                            relatedBy:NSLayoutRelationEqual
//                                                                               toItem:nil
//                                                                            attribute:NSLayoutAttributeNotAnAttribute
//                                                                           multiplier:1.0
//                                                                             constant:40];
//        /* 4. Add the constraints to button's superview*/
//        [self.view addConstraints:@[bttomButtonConstraint, leftButtonConstraint, heightConstraint, widthConstraint]];
    }
    
    button.userInteractionEnabled = YES;
    button.enabled = NO;
    
    
//    UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc]
//                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//
//    // Position the spinner
//    [myIndicator setCenter:CGPointMake(button.frame.size.width- 35, button.frame.size.height / 2)];
//
//    // Add to button
//    [button addSubview:myIndicator];
//
//    // Start the animation
//    [myIndicator startAnimating];
//    [myIndicator setHidesWhenStopped:YES];
    
    
    UBSDKRidesClient *ridesClient = [[UBSDKRidesClient alloc] init];
    
    if (_isFromSearch){
        
        destinationAdd = [NSString stringWithFormat:@"%@,%@,%@", _dictEventInfo2[@"event_venue"], _dictEventInfo2[@"event_address"],_dictEventInfo2[@"event_city"]];
    }else{
        destinationAdd = [NSString stringWithFormat:@"%@,%@,%@", _dictEventInfo[@"event_venue"], _dictEventInfo[@"event_address"],_dictEventInfo[@"event_city"]];
    }
    
    CLLocationCoordinate2D destinationCenter =  [self getLocationFromAddressString:destinationAdd];
    
//    CLLocation *pickupLocation = [[CLLocation alloc] initWithLatitude: 30.7046 longitude: 76.7179];
    CLLocation *pickupLocation = [[LocationTracker sharedLocationManager] location];
    CLLocation *dropoffLocation = [[CLLocation alloc] initWithLatitude: destinationCenter.latitude longitude: destinationCenter.longitude];
    
    
    NSString *dropoffNickname = labelEventName.text;
    
    __block UBSDKRideParametersBuilder *builder = [[UBSDKRideParametersBuilder alloc] init];
    [builder setPickupLocation: pickupLocation];
    [builder setDropoffLocation:dropoffLocation];
    [builder setDropoffNickname:dropoffNickname];
    [builder setDropoffAddress:destinationAdd];
    button.rideParameters = [builder build];
    [button loadRideInformation];
//    builder = [builder setPickupToCurrentLocation];
//    builder = [builder setDropoffLocation: dropoffLocation nickname: dropoffNickname address:destinationAdd];
    button.enabled = YES;
    
    
//    [ridesClient fetchProductsWithPickupLocation:pickupLocation completion:^(NSArray<UBSDKProduct *> * _Nonnull products, UBSDKResponse * _Nonnull response) {
//        if (products.firstObject) {
//            [myIndicator stopAnimating];
//            [myIndicator setHidesWhenStopped:YES];
//            myIndicator.hidden = YES;
//
//            [builder setProductID: products.firstObject.productID];
//            button.rideParameters = [builder build];
//            [button loadRideInformation];
//            button.enabled = YES;
//        }
//    }];
    
    
//    [ridesClient fetchCheapestProductWithPickupLocation: pickupLocation completion:^(UBSDKUberProduct* _Nullable product, UBSDKResponse* _Nullable response) {
//        if (product) {
//            [myIndicator stopAnimating];
//            [myIndicator setHidesWhenStopped:YES];
//            myIndicator.hidden = YES;
//
//            builder = [builder setProductID: product.productID];
//            button.rideParameters = [builder build];
//            [button loadRideInformation];
//            button.enabled = YES;
//
//        }
//    }];
    
}


-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) address {
    
    double latitude = 0, longitude = 0;
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *esc_addr = [address stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    
    //30.7333
    //76.7794
    if (center.latitude == 0.000000 && center.longitude==0.000000) {
        
        double latitude = 0, longitude = 0;
        
        NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
        NSString *esc_addr = [address stringByAddingPercentEncodingWithAllowedCharacters:set];
        
        NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
        
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
        if (result) {
            NSScanner *scanner = [NSScanner scannerWithString:result];
            if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
                [scanner scanDouble:&latitude];
                if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                    [scanner scanDouble:&longitude];
                }
            }
        }
        CLLocationCoordinate2D center;
        center.latitude=latitude;
        center.longitude = longitude;
        NSLog(@"View Controller get Location Logitute : %f",center.latitude);
        NSLog(@"View Controller get Location Latitute : %f",center.longitude);
        
        //        CLLocation *source = [[CLLocation alloc]initWithLatitude:mylatitude longitude:mylongitude];
        //        CLLocation *destination = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        
        //        [self LocationWithLet:source withUserLocation:destination];
        
    }else{
        
        //        CLLocation *source = [[CLLocation alloc]initWithLatitude:mylatitude longitude:mylongitude];
        //        CLLocation *destination = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        
        //        [self LocationWithLet:source withUserLocation:destination];
        
    }
    
    return center;
}

- (IBAction)next:(id)sender
{
    [viewSlideShow next];
}

- (IBAction)previous:(id)sender
{
    [viewSlideShow previous];
}

-(IBAction)clickPageControl:(id)sender
{
    [viewSlideShow previous];
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self uberButton];
    [self updateCount];
    
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
    
    //MFSideMenuPanModeDefault
    // This padding will be observed by the mapView
    // self.mapContainerView.padding = UIEdgeInsetsMake(64, 0, 64, 0);
    
    // KASlideshow
    viewSlideShow.datasource = self;
    
    viewSlideShow.delegate = self;
    
    [viewSlideShow setDelay:1]; // Delay between transitions
    
    [viewSlideShow setTransitionDuration:.5]; // Transition duration
    
    // Choose a transition type (fade or slide)
    [viewSlideShow setTransitionType:KASlideShowTransitionSlideHorizontal];
    
    // Choose a content mode for images to display
    //[viewSlideShow setImagesContentMode:UIViewContentModeScaleAspectFit];
    [viewSlideShow setImagesContentMode:UIViewContentModeScaleAspectFill];
    
    // Gesture to go previous/next directly on the image
    [viewSlideShow addGesture:KASlideShowGestureSwipe];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    

    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_description"]]]==true || [STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_description"]]]==true)
    {
         [containerView setHidden:YES];
    }
    else
    {
        
    }
    
//    if ([self.dictEventInfo[@"event_description"] isEqualToString:@""] || [self.dictEventInfo2[@"event_description"] isEqualToString:@""] )
//    {
//        [containerView setHidden:YES];
//    }
//    else
//    {
//
//    }
    
    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_pic"]]]==true || [STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_pic"]]]==true){
        
        imageViewEvent.contentMode = UIViewContentModeScaleAspectFill;
        imageViewEvent.image = [UIImage imageNamed:@"logo"];
    }
    
//    if ([self.dictEventInfo[@"event_pic"] isEqualToString:@""] || [self.dictEventInfo2[@"event_pic"] isEqualToString:@""]){
//
//        imageViewEvent.contentMode = UIViewContentModeScaleAspectFill;
//        imageViewEvent.image = [UIImage imageNamed:@"logo"];
//    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KASlideShow datasource

- (NSObject *)slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index
{
    return datasource[index];
}

- (NSUInteger)slideShowImagesNumber:(KASlideShow *)slideShow
{
    return datasource.count;
}


#pragma mark - KASlideShow delegate

//- (void) slideShowWillShowNext:(KASlideShow *)slideShow
//{
//
//    pageControl.currentPage=slideShow.currentIndex;
//}
//
//- (void) slideShowWillShowPrevious:(KASlideShow *)slideShow
//{
//    pageControl.currentPage=slideShow.currentIndex;
//}

- (void) slideShowDidShowNext:(KASlideShow *)slideShow
{
    pageControl.currentPage=slideShow.currentIndex;
    showIndexOnLabel = slideShow.currentIndex +1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateCount];
    });
}

-(void) slideShowDidShowPrevious:(KASlideShow *)slideShow
{
    pageControl.currentPage=slideShow.currentIndex;
    showIndexOnLabel = slideShow.currentIndex + 1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateCount];
    });
}

//- (void) slideShowDidSwipeLeft:(KASlideShow *) slideShow{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self updateCount];
//    });
//
//}
//- (void) slideShowDidSwipeRight:(KASlideShow *) slideShow{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self updateCount];
//    });
//}

- (void)updateCount{
    
        self.countLabel.backgroundColor = [UIColor clearColor];
        self.countLabel.layer.cornerRadius = 4;
        self.countLabel.clipsToBounds = YES;
        self.countLabel.font = [UIFont fontWithName:@"Lato" size:12.0];
        self.countLabel.textColor = [UIColor darkGrayColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
    
    if (showIndexOnLabel == 0) {
        showIndexOnLabel=1;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%lu",(unsigned long)showIndexOnLabel, (unsigned long)[datasource count]];
    
    self.countLabel.font = [UIFont fontWithName:@"lato-Bold" size:12];   
    
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
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT+1"];
   // NSTimeZone *gmt = [NSTimeZone systemTimeZone];

    [df setTimeZone:gmt];
    
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

        NSString *substring = @"AM";
        
        BOOL Yes = [timeString localizedCaseInsensitiveContainsString:substring];
        
        if (Yes == true) {
            
            [df setDateFormat:@"hh:mm a"];
            
        }else{
            
            NSString *substring = @"PM";
            BOOL Yes = [timeString localizedCaseInsensitiveContainsString:substring];
            
            if (Yes == true) {
                
                [df setDateFormat:@"hh:mm a"];
                
            }else{
                
                NSString *substring = @"am";
                BOOL Yes = [timeString localizedCaseInsensitiveContainsString:substring];
                
                if (Yes == true) {
                    [df setDateFormat:@"hh:mm a"];
                }else{
                    NSString *substring = @"pm";
                    BOOL Yes = [timeString localizedCaseInsensitiveContainsString:substring];
                    
                    if (Yes == true) {
                        [df setDateFormat:@"hh:mm a"];
                    }else{
                        
                        [df setDateFormat:@"hh:mm"];
                    }
                }
            }
        }
    }
    else
    {
        [df setDateFormat:@"HH:mm"];
    }
    
    df.calendar=NSCalendar.currentCalendar;
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT+1"];
   
   // NSTimeZone *gmt = [NSTimeZone systemTimeZone];
    [df setTimeZone:gmt];
    
    NSDate *date = [df dateFromString:timeString];
    
    [df setDateFormat:@"HH:mm"];
    
    NSString *timeStr = [df stringFromDate:date];
    
    return timeStr;
}


- (IBAction)buttonShareClicked:(UIButton *)sender
{
    
    //NSString *textToShare = @"Check out the app “CityBud: Find events & more”, you can download the iPhone App from this link:";
    //NSURL *myWebsite = [NSURL URLWithString:@"https://itunes.apple.com/us/app/citybud/id1279160557?ls=1&mt=8"];
    
    NSString *textToShare,*myWebsite;
    NSString *eventIdStr,*fromtableStr;
    
    if(_isFromSearch){
        
        if (_showUberView){
            
            textToShare = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_name"]];
            eventIdStr = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"id"]];
            fromtableStr = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"fromtable"]];
            
        }else{
            textToShare = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_name"]];
            eventIdStr = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"id"]];
            fromtableStr = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"fromtable"]];
        }
    }else{
        
        if (_showUberView){
            
            textToShare = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_name"]];
            eventIdStr = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"id"]];
            fromtableStr = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"fromtable"]];
            
        }else{
            textToShare = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_name"]];
            eventIdStr = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"id"]];
            fromtableStr = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"fromtable"]];
        }
        
    }
    
    // http://citybudng.com/view_event?id=584&from=uvent_event
    
    if ([fromtableStr isEqualToString:@"uvent_event"]) {
        
         myWebsite = [NSString stringWithFormat:@"http://citybudng.com/view_event?id=%@&from=%@",eventIdStr,fromtableStr];
    }
    else{
       myWebsite = [NSString stringWithFormat:@"http://citybudng.com/view_all?id=%@&from=%@",eventIdStr,fromtableStr];
    }
    
    NSURL *MyUrl = [NSURL URLWithString:myWebsite];
    
    //NSString *textToShare = @"Check out the app “CityBud: Find events & more”, you can download the iPhone App from this link:";
    
    NSArray *objectsToShare = @[textToShare, MyUrl];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   ];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(IBAction)PayButonClick:(UIButton*)sender
{
    if ([AFNetworkReachabilityManager sharedManager].isReachable){
        SHOW_NETWORK_ERROR_ALERT();
        return;
    }else{
        
        if (_isFromSearch){
            dictParam = [@{
                           @"event_city":[NSString stringWithFormat:@"%@", _dictEventInfo2[@"event_city"]],
                           @"event_id":[NSString stringWithFormat:@"%@", _dictEventInfo2[@"id"]]
                           }mutableCopy];
        }else{
            dictParam = [@{
                           @"event_city":[NSString stringWithFormat:@"%@", _dictEventInfo[@"event_city"]],
                           @"event_id":[NSString stringWithFormat:@"%@", _dictEventInfo[@"id"]]
                           }mutableCopy];
        }
        
        CBGetTicketViewController * GetTicket = [self.storyboard instantiateViewControllerWithIdentifier:@"CBGetTicketViewController"];
        
        GetTicket.dictParamForGetTicket = dictParam;
        
        [self.navigationController pushViewController:GetTicket animated:YES];        
    }

    
}

- (IBAction)buttonBackClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)getLocation:(UIButton *)sender
{
    
    //Navigate to Map Screen with path b/w source and destination
    [self performSegueWithIdentifier:@"CBMapDirectionViewController" sender:nil];
    
    //
    //    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
    //                                                            longitude:151.2086
    //                                                                 zoom:16];
    //
    //    self.mapContainerView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    //    self.mapContainerView.settings.compassButton = YES;
    //    self.mapContainerView.settings.myLocationButton = YES;
    //    self.mapContainerView.myLocationEnabled = YES;
    //    self.mapContainerView.delegate=self;
    //    [self.mapContainerView setMinZoom:10 maxZoom:18];
    //    // Listen to the myLocation property of GMSMapView.
    //    /*[self.mapContainerView addObserver:self
    //     forKeyPath:@"myLocation"
    //     options:NSKeyValueObservingOptionNew
    //     context:NULL];*/
    //
    //    //[_viewForMap addSubview: self.mapContainerView];
    //
    //    // [self.view addSubview:self.mapContainerView];
    //
    //    self.view = self.mapContainerView;
    //
    //
    //    [self getLocationFromAddressString:@"IVY hospital, sector 71, Mohali"];
    //
    
}


- (IBAction)actionAddToCalander:(UIButton *)sender {
    
    store = [[EKEventStore alloc] init];
    
    if([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // iOS 6
        [store requestAccessToEntityType:EKEntityTypeEvent
                              completion:^(BOOL granted, NSError *error) {
                                  if (granted)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self createEventAndPresentViewController:store];
                                      });
                                  }
                              }];
    } else
    {
        // iOS 5
        [self createEventAndPresentViewController:store];
    }
    
}

- (IBAction)actionEventUber:(UIButton *)sender {
    // Objective-C
    
    
}

- (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation *)destination completionHandler:(void (^)(GMSPolyline *))completionHandler
{
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if(error)
        {
            if(completionHandler)
            completionHandler(nil);
            return;
        }
        
        NSArray *routesArray = [json objectForKey:@"routes"];
        
        __block GMSPolyline *polyline = nil;
        
        
        if ([routesArray count] > 0)
        
        {
            NSDictionary *routeDict = [routesArray objectAtIndex:0];
            
            NSDictionary * dataDict1,* dataDict2,*startLoc,*StopLoc,*endLoc;
            
            if ([[routeDict valueForKey:@"legs"] count]==1)
            {
                
                dataDict1 = [[routeDict valueForKey:@"legs"] objectAtIndex:0];
                
                endLoc= [dataDict1 valueForKey:@"end_location"];
                
                startLoc= [dataDict1 valueForKey:@"start_location"];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                
                NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                
                GMSPath *path = [GMSPath pathFromEncodedPath:points];
                
                polyline = [GMSPolyline polylineWithPath:path];
                
                polyline.strokeWidth=5.0;
                
                polyline.strokeColor=[UIColor darkGrayColor];
                
                
                if(completionHandler)
                
                completionHandler(polyline);
            });
        }
        
    }];
    
    [fetchDirectionsTask resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"CBMapDirectionViewController"]){
        CBMapDirectionViewController *mapVC = segue.destinationViewController;
        
        if(_isFromSearch)
        {
            
            NSString *latstr = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"lat"]];
            NSString *longstr = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"long"]];
            NSString *Addressstr = [NSString stringWithFormat:@"%@,%@,%@", _dictEventInfo2[@"event_venue"], _dictEventInfo2[@"event_address"],_dictEventInfo2[@"event_city"]];
            
            
            
            if ([STMethod stringIsEmptyOrNot:latstr] == false && [STMethod stringIsEmptyOrNot:longstr] == false) {
                
                mapVC.strEventName = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_name"]];
                
                mapVC.DestinationLatitude=[self.dictEventInfo2[@"lat"] doubleValue];
                
                mapVC.DestinationLongitude=[self.dictEventInfo2[@"long"] doubleValue];
                
                mapVC.fullAddress = [NSString stringWithFormat:@"%@,%@,%@", _dictEventInfo2[@"event_venue"], _dictEventInfo2[@"event_address"],_dictEventInfo2[@"event_city"]];
                
            }else{
                
                if ([STMethod stringIsEmptyOrNot:Addressstr] == false) {
                    
                    double latitude = 0, longitude = 0;
                    
                    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
                    NSString *esc_addr = [Addressstr stringByAddingPercentEncodingWithAllowedCharacters:set];
                    
                    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
                    
                    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
                    if (result) {
                        NSScanner *scanner = [NSScanner scannerWithString:result];
                        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
                            [scanner scanDouble:&latitude];
                            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                                [scanner scanDouble:&longitude];
                            }
                        }
                    }
                    CLLocationCoordinate2D center;
                    center.latitude=latitude;
                    center.longitude = longitude;
                    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
                    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
                    
                    
                     if (center.latitude == 0.000000 && center.longitude==0.000000) {
                         
                         UIAlertController * alert = [UIAlertController
                                                      alertControllerWithTitle:@"CityBud"
                                                      message:@"Event Address is not found !!!"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                         
                         //Add Buttons Address
                         
                         UIAlertAction* noButton = [UIAlertAction
                                                    actionWithTitle:@"Ok"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        //Handle no, thanks button
                                                    }];
                         
                         //Add your buttons to alert controller
                         [alert addAction:noButton];
                         
                         [self presentViewController:alert animated:YES completion:nil];
                         
                     }else{
                         mapVC.strEventName = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_name"]];
                         mapVC.DestinationLatitude=center.latitude;
                         mapVC.DestinationLongitude=center.longitude;
                         mapVC.fullAddress = [NSString stringWithFormat:@"%@,%@,%@", _dictEventInfo2[@"event_venue"], _dictEventInfo2[@"event_address"],_dictEventInfo2[@"event_city"]];
                     }
                    
                }
                else
                {
                    
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"CityBud"
                                                 message:@"Event Address is not found !!!"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    //Add Buttons
                    
                    UIAlertAction* noButton = [UIAlertAction
                                               actionWithTitle:@"Ok"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Handle no, thanks button
                                               }];
                    
                    //Add your buttons to alert controller
                    [alert addAction:noButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            
        }else
        {
            
            NSString *latstr = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"lat"]];
            NSString *longstr = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"long"]];
            NSString *Addressstr = [NSString stringWithFormat:@"%@,%@,%@", _dictEventInfo[@"event_venue"], _dictEventInfo[@"event_address"],_dictEventInfo[@"event_city"]];
            
            
            
            if ([STMethod stringIsEmptyOrNot:latstr] == false && [STMethod stringIsEmptyOrNot:longstr] == false) {
                
                mapVC.strEventName = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"event_name"]];
                mapVC.DestinationLatitude=[self.dictEventInfo[@"lat"] doubleValue];
                mapVC.DestinationLongitude=[self.dictEventInfo[@"long"] doubleValue];
                mapVC.fullAddress = [NSString stringWithFormat:@"%@,%@,%@", _dictEventInfo[@"event_venue"], _dictEventInfo[@"event_address"],_dictEventInfo[@"event_city"]];
                
            }else{
                
                if ([STMethod stringIsEmptyOrNot:Addressstr] == false) {
                    
                    double latitude = 0, longitude = 0;
                    
                    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
                    NSString *esc_addr = [Addressstr stringByAddingPercentEncodingWithAllowedCharacters:set];
                    
                    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
                    
                    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
                    if (result) {
                        NSScanner *scanner = [NSScanner scannerWithString:result];
                        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
                            [scanner scanDouble:&latitude];
                            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                                [scanner scanDouble:&longitude];
                            }
                        }
                    }
                    CLLocationCoordinate2D center;
                    center.latitude=latitude;
                    center.longitude = longitude;
                    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
                    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
                    
                    
                    if (center.latitude == 0.000000 && center.longitude==0.000000) {
                        
                        UIAlertController * alert = [UIAlertController
                                                     alertControllerWithTitle:@"CityBud"
                                                     message:@"Event Address is not found !!!"
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        //Add Buttons
                        
                        UIAlertAction* noButton = [UIAlertAction
                                                   actionWithTitle:@"Ok"
                                                   style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       //Handle no, thanks button
                                                   }];
                        
                        //Add your buttons to alert controller
                        [alert addAction:noButton];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }else{
                        mapVC.strEventName = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"event_name"]];
                        mapVC.DestinationLatitude=center.latitude;
                        mapVC.DestinationLongitude=center.longitude;
                        mapVC.fullAddress = [NSString stringWithFormat:@"%@,%@,%@", _dictEventInfo[@"event_venue"], _dictEventInfo[@"event_address"],_dictEventInfo[@"event_city"]];
                    }
                    
                }else{
                    
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"CityBud"
                                                 message:@"Event Address is not found !!!"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    //Add Buttons
                    
                    UIAlertAction* noButton = [UIAlertAction
                                               actionWithTitle:@"Ok"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Handle no, thanks button
                                               }];
                    
                    //Add your buttons to alert controller
                    [alert addAction:noButton];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }
            
        }
    }
}

#pragma mark - Button Actions

- (void)AlertForInValidMobileNumber
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"CityBud"
                                 message:@"Mobile number is not Valid !!!"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)actionEventPhone:(UIButton *)sender {
    
    if(_isFromSearch){
        
        NSString *newString = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"phone"]];
        newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        if ([STMethod stringIsEmptyOrNot:newString] == false) {
            newString = [NSString stringWithFormat:@"telprompt://%@",self.dictEventInfo[@"phone"]];
            NSURL *phoneNumber = [NSURL URLWithString:newString];
            [[UIApplication sharedApplication] openURL:phoneNumber];
            
        }else{
            
            [self AlertForInValidMobileNumber];
        }
        
    }else{
        
        NSString *newString = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"phone"]];
        newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];

        if ([STMethod stringIsEmptyOrNot:newString] == false) {
            
            newString = [NSString stringWithFormat:@"telprompt://%@",self.dictEventInfo[@"phone"]];
            NSURL *phoneNumber = [NSURL URLWithString:newString];
            [[UIApplication sharedApplication] openURL:phoneNumber];
            
        }else{
            
            [self AlertForInValidMobileNumber];
        }
    }
}

- (IBAction)actionEventWeb:(UIButton *)sender {
    
    if(_isFromSearch){
        
        NSString *SiteURL = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"siteurl"]];
        
         if ([STMethod stringIsEmptyOrNot:SiteURL] == false) {
             
             SiteURL=[SiteURL stringByReplacingOccurrencesOfString:@" " withString:@""];
             NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
             
             
             if ([SiteURL.lowercaseString hasPrefix:@"http://"] || [SiteURL.lowercaseString hasPrefix:@"https://"])
             {
                 candidateURL = [[NSURL alloc]initWithString:[SiteURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
             }
             else
             {
                 candidateURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
             }
             
             if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
             {
                 [[UIApplication sharedApplication] openURL:candidateURL options:@{} completionHandler:^(BOOL success) {
                     
                 }];
             }
             else
             {
                 [self AlertForInValidURL];
             }
         }else{
             
             NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://citybudng.com/"]];
             [[UIApplication sharedApplication] openURL:candidateURL options:@{} completionHandler:^(BOOL success) {
                 
             }];
         }
        
    }else{
        
        NSString *SiteURL = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"siteurl"]];
        
        
        if ([STMethod stringIsEmptyOrNot:SiteURL] == false) {
            
            SiteURL=[SiteURL stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
            
            
            if ([SiteURL.lowercaseString hasPrefix:@"http://"] || [SiteURL.lowercaseString hasPrefix:@"https://"])
            {
                candidateURL = [[NSURL alloc]initWithString:[SiteURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            }
            else
            {
                candidateURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
            }
            
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                [[UIApplication sharedApplication] openURL:candidateURL options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
            else
            {
                [self AlertForInValidURL];
            }
        }else{
            
            NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://citybudng.com/"]];
            [[UIApplication sharedApplication] openURL:candidateURL options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    }
}

- (void)AlertForInValidURL
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"CityBud"
                                 message:@"The Website URL is not Valid !!!"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)actionEventPhone2:(id)sender {
    
    NSLog(@"%@",self.dictEventInfo2);
    
    if(_isFromSearch){
        
        NSString *newString = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"phone"]];
        newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        if ([STMethod stringIsEmptyOrNot:newString] == false) {
            newString = [NSString stringWithFormat:@"telprompt://%@",self.dictEventInfo[@"phone"]];
            NSURL *phoneNumber = [NSURL URLWithString:newString];
            [[UIApplication sharedApplication] openURL:phoneNumber];
            
        }else{
         
            [self AlertForInValidMobileNumber];
        }
        
        
        
    }else{
        
        NSString *newString = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"phone"]];
        newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ([STMethod stringIsEmptyOrNot:newString] == false) {
            newString = [NSString stringWithFormat:@"telprompt://%@",self.dictEventInfo[@"phone"]];
            NSURL *phoneNumber = [NSURL URLWithString:newString];
            [[UIApplication sharedApplication] openURL:phoneNumber];
            
        }else{
            
            [self AlertForInValidMobileNumber];
        }
    }
}

- (IBAction)actionEventWeb2:(UIButton *)sender {
    
    if(_isFromSearch){
        
        NSString *SiteURL = [NSString stringWithFormat:@"%@",self.dictEventInfo2[@"siteurl"]];
        
        if ([STMethod stringIsEmptyOrNot:SiteURL] == false) {
            
            SiteURL=[SiteURL stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
            
            
            if ([SiteURL.lowercaseString hasPrefix:@"http://"] || [SiteURL.lowercaseString hasPrefix:@"https://"])
            {
                candidateURL = [[NSURL alloc]initWithString:[SiteURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            }
            else
            {
                candidateURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
            }
            
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                [[UIApplication sharedApplication] openURL:candidateURL options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
            else
            {
                [self AlertForInValidURL];
            }
        }else{
            
            NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://citybudng.com/"]];
            [[UIApplication sharedApplication] openURL:candidateURL options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    }else{
        
        NSString *SiteURL = [NSString stringWithFormat:@"%@",self.dictEventInfo[@"siteurl"]];

        if ([STMethod stringIsEmptyOrNot:SiteURL] == false) {
            
            SiteURL=[SiteURL stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
            
            
            if ([SiteURL.lowercaseString hasPrefix:@"http://"] || [SiteURL.lowercaseString hasPrefix:@"https://"])
            {
                candidateURL = [[NSURL alloc]initWithString:[SiteURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            }
            else
            {
                candidateURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@",SiteURL]];
            }
            
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                [[UIApplication sharedApplication] openURL:candidateURL options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
            else
            {
                [self AlertForInValidURL];
            }
        }else{
            
            NSURL *candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://citybudng.com/"]];
            [[UIApplication sharedApplication] openURL:candidateURL options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    }
}

- (IBAction)actionEventUber2:(UIButton *)sender {
}

#pragma mark - Add to Calendar

- (void)createEventAndPresentViewController:(EKEventStore *)store
{
    event = [self findOrCreateEvent:store];

    EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
    controller.event = event;
    controller.eventStore = store;
    controller.editViewDelegate = self;

    [self presentViewController:controller animated:YES completion:nil];
}


- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (EKEvent *)findOrCreateEvent:(EKEventStore *)store
{
    //set Event name
    NSString *title = labelEventName.text;

    // try to find an event

    EKEvent *event = [self findEventWithTitle:title inEventStore:store];

    // if found, use it
    

    

    if (event) {
        
            UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"CityBud"
                                     message:@"The event is already added in your calender!!!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
            //Add Buttons
        
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Ok"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle no, thanks button
                                       }];
        
            //Add your buttons to alert controller
            [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
            return nil;
    }else{
        
        // if not, let's create new event
        
        event = [EKEvent eventWithEventStore:store];
        
        event.title = title;
        event.notes = @"CityBud Event Notes";
        event.location = [NSString stringWithFormat:@"%@",destinationAdd];
        event.calendar = [store defaultCalendarForNewEvents];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.hour = 4;
        
        NSString *strDate = [NSString new];
        if (_isFromSearch){
            strDate = _dictEventInfo2[@"event_date"];
        }else{
            strDate = _dictEventInfo[@"event_date"];
        }
        
        NSDateFormatter *dateFormatter12 = [[NSDateFormatter alloc] init];
        NSTimeZone *local = [NSTimeZone localTimeZone];
        [dateFormatter12 setTimeZone:local];
        [dateFormatter12 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter12 dateFromString:strDate];
        
        //     NSDate *date = [self getDateFromDateDtring:strDate];
        
        
        
        //    event.startDate = [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
    
        event.startDate = [calendar dateByAddingComponents:components toDate:date options:0];
        components.hour = 1;
        event.endDate = [calendar dateByAddingComponents:components toDate:event.startDate options:0];
        
        return event;
    }
    
}

- (EKEvent *)findEventWithTitle:(NSString *)title inEventStore:(EKEventStore *)store
{
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];

    // Create the start range date components
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];

    // Create the end range date components
    NSDateComponents *oneWeekFromNowComponents = [[NSDateComponents alloc] init];
    oneWeekFromNowComponents.day = 365;
    NSDate *oneWeekFromNow = [calendar dateByAddingComponents:oneWeekFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];

    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneWeekFromNow
                                                          calendars:nil];

    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];

    for (EKEvent *event in events)
    {
        if ([title isEqualToString:event.title])
        {
            return event;
        }
    }

    return nil;
}

/*
 
 -(void)getAllCalendars
 {
 calendarArray = [[NSMutableArray alloc]initWithCapacity:0];
 store = [[EKEventStore alloc]init];
 [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)    {
 if (error == nil) {
 // Store the returned granted value.
 calendarArray = (NSMutableArray *)[self getLocalCalendars];
 
 }
 else{
 // In case of error, just log its description to the debugger.
 NSLog(@"%@", [error localizedDescription]);
 }
 }];
 
 }
 
 -(NSArray *)getLocalCalendars
 {
 
 NSArray *allCalendars = [store calendarsForEntityType:EKEntityTypeEvent];
 NSMutableArray *localCalendars = [[NSMutableArray alloc] init];
 
 for (int i=0; i< [allCalendars count]; i++) {
 EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
 if (currentCalendar.allowsContentModifications)
 {
 [localCalendars addObject:currentCalendar];
 }
 }
 return (NSArray *)localCalendars;
 }
 */

@end
