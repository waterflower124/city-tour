//
//  USUserInfoModel.m
//  Ustar
//
//  Created by Praveen Sharma on 9/20/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//

#import "USUserInfoModel.h"

@implementation USUserInfoModel

@synthesize email;
@synthesize firstname;
@synthesize surname;
@synthesize profile_pic;
@synthesize user_id;
@synthesize user_event_type;
@synthesize user_phone_number;
@synthesize arrayEvents;
@synthesize user_city;
@synthesize login_type,mobilenumber; //1 login via info, 2 login via social

+(USUserInfoModel *) sharedInstance {
    static USUserInfoModel *initObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        initObj = [[USUserInfoModel alloc] init];
    });
    
    return initObj;
}

@end
