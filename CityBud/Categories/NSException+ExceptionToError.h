//
//  NSException+ExceptionToError.h
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

extern const int ERROR_CODE_EXCEPTION;

@interface NSException (ExceptionToError)

-(NSError *) exceptionError;

@end
