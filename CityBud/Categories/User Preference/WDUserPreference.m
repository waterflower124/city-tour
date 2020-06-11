//
//  btcUserPreference.m
//  BaladeTonChien
//
//  Created by Ajay Chaudhary on 18/03/15.
//  Copyright (c) 2015 Imvisile Solution Pvt. Ltd. All rights reserved.
//

#import "WDUserPreference.h"

@implementation WDUserPreference

/*
 * set id type object in NSUserDefault......
 */
+ (void) setObject:(id)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/*
 * return id type object from NSUserDefault....
 */
+ (id) objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
}


/*
 * set Bool value in NSUserDefault......
 */
+ (void) setBool:(BOOL)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/*
 * return Bool value from NSUserDefault....
 */
+ (BOOL) boolForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
}
@end
