//
//  AppDelegate.h
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Paystack/Paystack.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

    {
        id _services;
    }
   

@property BOOL signUP;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString * attendingPeople;

@property (strong, nonatomic) NSString * ValueStr;

@end

