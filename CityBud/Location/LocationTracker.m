//
//  LocationTracker.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location All rights reserved.
//

#import "LocationTracker.h"

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation LocationTracker

+ (CLLocationManager *)sharedLocationManager {
	static CLLocationManager *_locationManager;
	
	@synchronized(self) {
		if (_locationManager == nil) {
			_locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
		}
	}
	return _locationManager;
}

+(LocationTracker *) sharedInstance
{
    static LocationTracker
    *locationTracker;
    @synchronized(self) {
        if(locationTracker==nil) {
            locationTracker= [LocationTracker new];
        }
    }
    return locationTracker;
}


- (id)init {
    if (self==[super init]) {
        
    }
    return self;
}


-(void)applicationEnterBackground{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void) restartLocationUpdates
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}


- (void)startLocationTracking {

    if (!self.reverseGeo) {
        self.reverseGeo = [[CLGeocoder alloc] init];
    }
	if ([CLLocationManager locationServicesEnabled] == NO) {
		UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[servicesDisabledAlert show];
	} else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted) {
            
            NSString *title = @"Location services is not enabled";
            NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
            alert.tag = 999;
            [alert show];

        } else {
            CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            
            if(IS_OS_8_OR_LATER) {
              [locationManager requestAlwaysAuthorization];
              [locationManager requestWhenInUseAuthorization];
             
            }
            [locationManager startUpdatingLocation];
            
            //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
            //The location manager will only operate for 10 seconds to save battery
            if (self.delay10Seconds) {
                [self.delay10Seconds invalidate];
                self.delay10Seconds = nil;
            }
            
            self.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                                 selector:@selector(stopLocationDelayBy10Seconds)
                                                                 userInfo:nil
                                                                  repeats:NO];
           
        }
	}
}


- (void)stopLocationTracking
{
    self.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.bgTask endAllBackgroundTasks];
    
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
   
	CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
	[locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Methods

-(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%f,%f&output=csv",pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return [locationString substringFromIndex:6];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
//    __block NSMutableString *fullAddress = [[NSMutableString alloc] init];    
//    __block NSString *address = nil;
//    __block NSString *country = nil;
//    __block NSString *city = nil;
//    __block NSString *postalCode=nil;
//    __block NSString *state=nil;

    CLLocation *loc = [locations lastObject];
    
    [self.reverseGeo reverseGeocodeLocation: [locations lastObject] completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         if (error) {
             
             NSLog(@"Error in detecting location %@", error.localizedDescription);
             
         }else{
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             self.dict_address = [NSMutableDictionary new];
             [self.dict_address setObject:[NSNumber numberWithFloat:loc.coordinate.latitude] forKey:@"latitude"];
             [self.dict_address setObject:[NSNumber numberWithFloat:loc.coordinate.longitude] forKey:@"longitude"];
             [self.dict_address setObject:placemark.country forKey:@"country"];
             
             [self updateLocationTracking];
         }
         
     }];

    if (self.timer) {
        return;
    }
    self.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 2 minute
    self.timer = [NSTimer scheduledTimerWithTimeInterval:120 target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    if (self.delay10Seconds)
    {
        return;
    }
    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
    self.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopLocationDelayBy10Seconds) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.delay10Seconds forMode:NSDefaultRunLoopMode];

}


-(void)stopLocationDelayBy10Seconds{
    
    if (self.delay10Seconds) {
        [self.delay10Seconds invalidate];
        self.delay10Seconds = nil;

    }
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{

    switch([error code])
    {
        case kCLErrorNetwork: {// general, network-related error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied: {
            
            NSString *title = @"Location services is not enabled";
            NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
            
            alert.tag = 999;
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}
//Send the location to Server
- (void)updateLocationTracking
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"COORDINATE" object:nil userInfo:self.dict_address ? self.dict_address : nil];
    
  //  [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdates object:nil userInfo:self.dict_address ? self.dict_address : nil];
   // NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Address: %@",[LocationTracker sharedLocationManager].location.coordinate.latitude, [LocationTracker sharedLocationManager].location.coordinate.longitude, self.dict_address);
    
  //  [UserPreference setObject:_dict_address[@"latitude"] forKey:Latitude];
  //  [UserPreference setObject:_dict_address[@"longitude"] forKey:Longitude];
    
}

@end
