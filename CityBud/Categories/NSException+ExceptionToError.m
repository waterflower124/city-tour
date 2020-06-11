//
//  NSException+ExceptionToError.m
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import "NSException+ExceptionToError.h"

const int ERROR_CODE_EXCEPTION = 12345;
@implementation NSException (ExceptionToError)

-(NSError *) exceptionError
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.name forKey:NSMachErrorDomain];
    [dict setObject:self.description forKey:NSLocalizedDescriptionKey];
    
    for (NSString *key in [self.userInfo allKeys]) {
        [dict setObject:[self.userInfo objectForKey:key] forKey:key];
    }

    NSError *error = [[NSError alloc] initWithDomain:self.name
                                                code:ERROR_CODE_EXCEPTION
                                            userInfo:dict];
    
    return error;
}

@end
