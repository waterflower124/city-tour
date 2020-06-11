//
//  btcUserPreference.h
//  BaladeTonChien
//
//  Created by Ajay Chaudhary on 18/03/15.
//  Copyright (c) 2015 Imvisile Solution Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDUserPreference : NSObject


+ (void) setObject:(id)object forKey:(NSString *)key;

+ (id) objectForKey:(NSString *)key;

+ (void) setBool:(BOOL)object forKey:(NSString *)key;

+ (BOOL) boolForKey:(NSString *)key;

@end
