//
//  NSString+CustomMethods.h
//  WalkingDogs
//
//  Created by Harjot Harry on 3/25/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (CustomMethods)

- (NSString *) encodeToURLString;
-(NSString *) timeStringFromDate: (NSDate *)date;

@end
