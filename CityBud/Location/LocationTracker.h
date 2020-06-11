//
//  LocationTracker.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BackgroundTaskManager.h"

@interface LocationTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLGeocoder *reverseGeo;
@property (nonatomic, strong) NSMutableDictionary *dict_address;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer * delay10Seconds;
@property (nonatomic, strong) BackgroundTaskManager * bgTask;


+ (CLLocationManager *)sharedLocationManager;
+(LocationTracker *) sharedInstance;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)updateLocationTracking;


@end
