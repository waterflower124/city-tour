//
//  NSError+CustomErrors.m
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import "NSError+CustomErrors.h"

const int ERROR_CODE_NO_NETWORK = 12346;
@implementation NSError (CustomErrors)

+(NSError *) noNetworkError
{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"Please check your internet connection and try again" forKey:NSLocalizedDescriptionKey];
    [dict setObject:@"Internet Error" forKey:NSMachErrorDomain];
    
    NSError *error = [[NSError alloc] initWithDomain:@"Internet Error"
                                                code:ERROR_CODE_NO_NETWORK
                                            userInfo:dict];
    return error;
}

@end
