//
//  USUserInfoModel.h
//  Ustar
//
//  Created by Praveen Sharma on 9/20/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USUserInfoModel : NSObject

@property (nonatomic, strong) NSString    *email;
@property (nonatomic, strong) NSString    *firstname;
@property (nonatomic, strong) NSString    *surname;
@property (nonatomic, strong) NSString    *profile_pic;
@property (nonatomic, strong) NSString    *user_id;
@property (nonatomic, strong) NSString    *user_phone_number;
@property (nonatomic, strong) NSString    *user_event_type;
@property (nonatomic, strong) NSString    *user_city;
@property (nonatomic, strong) NSString    *login_type;
@property (nonatomic, strong) NSString    *mobilenumber;

@property (nonatomic, strong) NSArray    *arrayEvents;

@property (strong, nonatomic) UINavigationController *navVC;

+(USUserInfoModel *) sharedInstance;

@end
