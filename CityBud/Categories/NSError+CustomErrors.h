//
//  NSError+CustomErrors.h
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

extern const int ERROR_CODE_NO_NETWORK;

@interface NSError (CustomErrors)

+(NSError *) noNetworkError;

@end
