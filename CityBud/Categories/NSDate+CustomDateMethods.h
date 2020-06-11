//
//  NSDate+CustomDateMethods.h
//  BaladeTonChien
//
//  Created by Ajay Chaudhary on 3/1/15.
//  Copyright (c) 2015 Imvisile Solution Pvt. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDate (CustomDateMethods)

- (NSDate *) toLocalTime;
- (NSDate *) toGlobalTime;
-(NSDate *) toUTCTime;

-(NSDate *)stringToDateWithAppFormmater:(NSString *)strDate;

- (NSString *) toLocalTimeString;
- (NSString *) toGMTTimeString;
- (NSString *) toServerTime;
- (NSString *) toDisplayTime;
-(NSString *)toWebServiceTime;

-(NSString *)getTimeDiffrenceFromTime:(NSString *)strDate;

+(NSInteger)weekdayFromString:(NSString *)weakDay;

-(NSString *)getUTCFromDate:(NSDate *)localDate;

@end
