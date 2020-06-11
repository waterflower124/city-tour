//
//  NSDate+CustomDateMethods.m
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import "NSDate+CustomDateMethods.h"

@implementation NSDate (CustomDateMethods)
/*
 Convert local time to GMT Time Zone....
 */
-(NSDate *) toLocalTime
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}


/*
 Calculate diffence between two dates....
 */
-(NSString *)getTimeDiffrenceFromTime:(NSString *)strDate{
   
    NSDate *date = [self stringToDateWithAppFormmater:strDate];
    
    if(date != nil){
        NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
        int timeDiffernce;
        if (secondsBetween<=59) {
            return [NSString stringWithFormat:@"Just now"];
        }else if (secondsBetween>=60 && secondsBetween<=3599){
            timeDiffernce = secondsBetween / 60;
            return [NSString stringWithFormat:@"%d mins ago",timeDiffernce];
        }else if (secondsBetween>= 3600 && secondsBetween<= 86399){
            timeDiffernce = secondsBetween / 3600;
            return [NSString stringWithFormat:@"%d hrs ago",timeDiffernce];
        }
        else{
            
            NSString *str = [date toLocalString];
            return str;
            
        }
    }else{
        return [NSString stringWithFormat:@"%@",@""];
    }
   
}


/*
 Convert local time to Global Time Zone....
 */
-(NSDate *)toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
//    tz = ;
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

-(NSString *)getUTCFromDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

-(NSDate *)toUTCTime
{
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}


- (NSString *)toLocalString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *local = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:local];
    [dateFormatter setDateFormat:@"MMM dd, yyyy  hh:mm a"];
    NSString *iso8601String = [dateFormatter stringFromDate:self];
    return iso8601String;
}


- (NSString *)toLocalTimeString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *local = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:local];
    [dateFormatter setDateFormat:@"MMM dd, yyyy 'T' hh:mm a"];
    NSString *iso8601String = [dateFormatter stringFromDate:self];
    return iso8601String;
}


- (NSString *)toGMTTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.000'Z'"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss z"];
    
    NSString *iso8601String = [dateFormatter stringFromDate:self];
    return iso8601String;
}


-(NSString *)toWebServiceTime{
    
        NSString *gmtDateString = [NSString stringWithFormat:@"%@", [self toGMTTimeString]];
    
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    
        //Create the date assuming the given string is in GMT
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSDate *date = [df dateFromString:gmtDateString];
    
        //Create a date string in the local timezone
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        NSString *serverTimeString = [df stringFromDate:date];
    
        NSLog(@"date = %@", serverTimeString);
    
//    NSString *iso8601String = @"";
    return serverTimeString;
}


/*
 To get start date of given month....
 */
-(NSDate *) startOfMonth
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:self];
    components.day = 1;
    
    NSDate *firstDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents: components];
    
    return firstDayOfMonthDate;
}

/*
 To add month number to given month number....
 */
- (NSDate *) dateByAddingMonths: (NSInteger) monthsToAdd
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setMonth: monthsToAdd];
    
    return [calendar dateByAddingComponents: months toDate: self options: 0];
}

/*
 To get end date of month....
 */
- (NSDate *)endOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * plusOneMonthDate = [self dateByAddingMonths:1];
    NSDateComponents * plusOneMonthDateComponents = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth fromDate: plusOneMonthDate];
    NSDate * endOfMonth = [[calendar dateFromComponents: plusOneMonthDateComponents] dateByAddingTimeInterval: -1];
    // One second before the start of next month
    
    return endOfMonth;
}

/*
 To get next or previous date from given date....
 */
-(NSDate *)nextOrPreviousMonthDate:(int)offSet
{
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.month = offSet;
    
    NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                                  toDate:self
                                                                                 options:0];
    return currentDatePlus1Month;
}


-(NSString *)toServerTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

-(NSString *)toDisplayTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MM yyyy HH:mm"];
    
    NSString *iso8601String = [dateFormatter stringFromDate:self];
    
    return iso8601String;
    
}


-(NSDate *)stringToDateWithAppFormmater:(NSString *)strDate{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    return [dateFormat dateFromString:strDate];
}

+(NSInteger)weekdayFromString:(NSString *)weakDay {
    if ([weakDay isEqualToString:@"Sunday"]) {
        return 1;
    } else if ([weakDay isEqualToString:@"Monday"]) {
        return 2;
    } else if ([weakDay isEqualToString:@"Tuesday"]) {
        return 3;
    } else if ([weakDay isEqualToString:@"Wednesday"]) {
        return 4;
    } else if ([weakDay isEqualToString:@"Thursday"]) {
        return 5;
    } else if ([weakDay isEqualToString:@"Friday"]) {
        return 6;
    } else if ([weakDay isEqualToString:@"Saturday"]) {
        return 7;
    }
    
    return 0;
}

@end
