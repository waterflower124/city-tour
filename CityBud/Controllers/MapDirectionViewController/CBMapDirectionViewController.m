//
//  CBMapDirectionViewController.m
//  CityBud
//
//  Created by Mohit Garg on 13/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBMapDirectionViewController.h"
#import <MapKit/MapKit.h>
#import "LocationTracker.h"
#import "STMethod.h"
#import "Constants.h"

@interface CBMapDirectionViewController () <UIActionSheetDelegate>
{
    double mylatitude, mylongitude;
    BOOL islocationupdated;
}

@property (nonatomic, strong) GMSMapView *mapView;

@end

@implementation CBMapDirectionViewController
{
    GMSMarker *markerCurrent;
    GMSCameraPosition *cameraPos;
    CLLocation *currentLocation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    SHOW_LOADING ();
    
    labelEventName.text = _strEventName;
    
    [[LocationTracker sharedInstance] startLocationTracking];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"COORDINATE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserCurrentLocation:) name:@"COORDINATE" object:nil];
    
    _DistanceInfoTop.constant=-100;
    
    [[LocationTracker sharedInstance] startLocationTracking];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    // Listen to the myLocation property of mapView.
    [_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
}


- (IBAction)GooglemapDirection:(UIButton *)sender {
    
    // Google maps installed

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Get Directions" message:@"Show Map :" preferredStyle:UIAlertControllerStyleActionSheet];

        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

            // Cancel button tappped.
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
        }]];

        [actionSheet addAction:[UIAlertAction actionWithTitle:@"View in Google maps" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            
            BOOL canHandle = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps:"]];
            
            if (canHandle) {
                
                currentAddressStr = [currentAddressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                destinationAddressStr = [destinationAddressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                NSString *temp=[NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@&directionsmode=drive",currentAddressStr,destinationAddressStr];
                
                NSURL *url;
                
                if(temp.length == 0 || [temp isKindOfClass:[NSNull class]] || [temp isEqualToString:@""]||[temp isEqualToString:@"(null)"]||temp==nil || [temp isEqualToString:@"<null>"]){
     
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&q=%f,%f&directionsmode=drive",mylatitude,mylongitude,_DestinationLatitude,_DestinationLongitude]];
                    
                } else {
                    
                    url = [NSURL URLWithString:temp];
                    
                }
               
                [[UIApplication sharedApplication] openURL:url];
                
            }else{
                
                // Use default browser maps
                [STMethod showAlert:self Title:@"" Message:@"Sorry, you don’t currently have Google maps installed on your phone." ButtonTitle:@"Ok"];
                
//                NSString* directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%f,%f",mylatitude,mylongitude, _DestinationLatitude, _DestinationLongitude];
//                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURL]];
            }

            
        }]];

//        [actionSheet addAction:[UIAlertAction actionWithTitle:@"View in Apple Maps" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//            // OK button tapped.
//
//            NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",mylatitude,mylongitude, _DestinationLatitude, _DestinationLongitude];
//
//            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURL]];
//
////            [self dismissViewControllerAnimated:YES completion:^{}];
//       }]];


    [actionSheet addAction:[UIAlertAction actionWithTitle:@"View in Browser" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        // Use default browser maps

        NSString* directionsURL = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%f,%f",mylatitude,mylongitude, _DestinationLatitude, _DestinationLongitude];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURL]];

//        [self dismissViewControllerAnimated:YES completion:^{}];
        }]];

    
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - KVO Updates...

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    currentLocation = [change objectForKey:NSKeyValueChangeNewKey];
    cameraPos = [GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:16];
    
    //
    // add marker for current location with car icon
    markerCurrent = [[GMSMarker alloc] init];
    markerCurrent.position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    markerCurrent.appearAnimation = NO;
    [markerCurrent setDraggable: NO];
    markerCurrent.icon = [UIImage imageNamed:@"car_icon"];
    markerCurrent.map = _mapView;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [markerCurrent setPosition:CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)];
        
    });
}


-(void)GetAddressFromUsingLatAndlong {

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:mylatitude longitude:mylongitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        if (placemark) {
            
                      NSLog(@"placemark %@",placemark);
                      //String to hold address
                      NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                      NSLog(@"addressDictionary %@", placemark.addressDictionary);
                      
                      NSLog(@"placemark %@",placemark.region);
                      NSLog(@"placemark %@",placemark.country);  // Give Country Name
                      NSLog(@"placemark %@",placemark.locality); // Extract the city name
                      NSLog(@"location %@",placemark.name);
                      NSLog(@"location %@",placemark.ocean);
                      NSLog(@"location %@",placemark.postalCode);
                      NSLog(@"location %@",placemark.subLocality);
                      
                      NSLog(@"location %@",placemark.location);
                      //Print the location to console
                      NSLog(@"I am currently at %@",locatedAt);
            
                     currentAddressStr = [NSString stringWithFormat:@"%@",locatedAt];
                  }
                  else {
                      NSLog(@"Could not locate");
                  }
        
                    HIDE_LOADING();
              }
     
     ];
}
 //currentAddressStr
    

-(void)getUserCurrentLocation:(NSNotification*)notification
{
    NSDictionary *dict = (NSDictionary *)notification.userInfo;
    
    if (dict)
    {
        [[LocationTracker sharedInstance] stopLocationTracking];
        mylatitude = [dict[@"latitude"] doubleValue];
        mylongitude = [dict[@"longitude"] doubleValue];
        
        [self GetAddressFromUsingLatAndlong];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:mylatitude longitude:mylongitude zoom:15];
        
        self.mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
        
        self.mapView.settings.compassButton = YES;
        self.mapView.settings.myLocationButton = YES;
        self.mapView.myLocationEnabled = YES;
        //[self.mapView setMinZoom:10 maxZoom:20];
        [self.viewForMap addSubview: self.mapView];
        
        NSLog(@"%@",self.fullAddress);
        destinationAddressStr = self.fullAddress;
        
        if (islocationupdated==NO)
        {
            islocationupdated=YES;
            
            CLLocation *source = [[CLLocation alloc]initWithLatitude:mylatitude longitude:mylongitude];
            
            if (_DestinationLatitude!=0.000000 && _DestinationLongitude!=0.000000)
            {
                CLLocation *destination = [[CLLocation alloc]initWithLatitude:_DestinationLatitude longitude:_DestinationLongitude];
                
                [self LocationWithLet:source withUserLocation:destination];
            }
            
            NSLog(@"%@",self.fullAddress);
            
            
            
            [self getLocationFromAddressString:self.fullAddress];
        }
    }
}

-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString *)address
{
    double latitude = 0, longitude = 0;
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *esc_addr = [address stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    
    
    //30.7333
    //76.7794
    if (center.latitude == 0.000000 && center.longitude==0.000000)
    {
        double latitude = 0, longitude = 0;
        
        NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
        NSString *esc_addr = [address stringByAddingPercentEncodingWithAllowedCharacters:set];
        
        NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
        
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
        if (result) {
            NSScanner *scanner = [NSScanner scannerWithString:result];
            if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
                [scanner scanDouble:&latitude];
                if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                    [scanner scanDouble:&longitude];
                }
            }
        }
        CLLocationCoordinate2D center;
        center.latitude=latitude;
        center.longitude = longitude;
        NSLog(@"View Controller get Location Logitute : %f",center.latitude);
        NSLog(@"View Controller get Location Latitute : %f",center.longitude);

        
        CLLocation *source = [[CLLocation alloc]initWithLatitude:mylatitude longitude:mylongitude];
        CLLocation *destination = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        
        
        _DestinationLatitude=destination.coordinate.latitude;
        
        _DestinationLongitude=destination.coordinate.longitude;
        
        // just to test filling static value of chandigarh
        //CLLocation *destination = [[CLLocation alloc]initWithLatitude:30.7333 longitude:76.7794 ];
        
        [self LocationWithLet:source withUserLocation:destination];
        
    }
    else
    {
        
        CLLocation *source = [[CLLocation alloc]initWithLatitude:mylatitude longitude:mylongitude];
        CLLocation *destination = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        
        _DestinationLatitude=destination.coordinate.latitude;
        
        _DestinationLongitude=destination.coordinate.longitude;
        
        // just to test filling static value of chandigarh
        //        CLLocation *destination = [[CLLocation alloc]initWithLatitude:30.7333 longitude:76.7794 ];
        
        [self LocationWithLet:source withUserLocation:destination];
    }
    
    return center;
}

#pragma mark - Call polylineFunctionDriverToUser
-(void) LocationWithLet:(CLLocation *) originLocation withUserLocation:(CLLocation *)destinationLocation
{
    [self fetchPolylineWithOrigin:originLocation destination:destinationLocation completionHandler:^(GMSPolyline *polyline, NSDictionary *dictionary) {
        
        if (polyline)
        {
            NSLog(@"allKeys :%@",[dictionary allKeys]);
            
            NSLog(@"distance %@",[[[[[[dictionary valueForKey:@"routes"] objectAtIndex:0] valueForKey:@"legs"] objectAtIndex:0] valueForKey:@"distance"]valueForKey:@"text"]);
            
            NSLog(@"Time %@",[[[[[[dictionary valueForKey:@"routes"] objectAtIndex:0] valueForKey:@"legs"] objectAtIndex:0] valueForKey:@"duration"] valueForKey:@"text"]);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //[self.mapView clear];
                
                polyline.map = self.mapView;
                
                // add marker on destination location
                GMSMarker *userMarker = [[GMSMarker alloc] init];
                userMarker.position =CLLocationCoordinate2DMake(originLocation.coordinate.latitude, originLocation.coordinate.longitude);
                userMarker.appearAnimation = NO;
                [userMarker setDraggable: NO];
                userMarker.icon = [UIImage imageNamed:@"location_details"];
                
                
                //marker.snippet = @"";
                userMarker.map = self.mapView;
                
                // add marker on start location
                GMSMarker *eventMarker = [[GMSMarker alloc] init];
                eventMarker.position =CLLocationCoordinate2DMake(destinationLocation.coordinate.latitude, destinationLocation.coordinate.longitude);
                eventMarker.appearAnimation = NO;
                [eventMarker setDraggable: NO];
                eventMarker.icon = [UIImage imageNamed:@"location_details"];
                eventMarker.map = self.mapView;
                
                CLLocationDistance dist=GMSGeometryDistance(originLocation.coordinate, destinationLocation.coordinate);
                
                NSLog(@"meters :%f", dist);
                
                //get distance in kilometers
                CLLocationDistance kilometers = dist / 1000.0;
                NSLog(@"kilometers :%f", kilometers);
                
                //Get distance in miles
                NSLog(@"Miles:%f",kilometers*0.62137);
                //convert kilometers to int value
                
                int num=kilometers;
                
                NSLog(@"kilometers :%d", num);
                
                NSMutableArray* markerArray = [[NSMutableArray alloc]initWithObjects:userMarker,eventMarker,markerCurrent, nil];
                [self focusMapToShowAllMarkers:markerArray];
                
            });
        }
    }];
}

#pragma mark - Show Marker in bounds

- (void)focusMapToShowAllMarkers:(NSMutableArray *) markerArray
{
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    
    for (GMSMarker *marker in markerArray)
        bounds = [bounds includingCoordinate:marker.position];
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:80.0f]];
}

- (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation *)destination completionHandler:(void(^)(GMSPolyline *polyline, NSDictionary *dictionary))completionHandler
//(void (^)(GMSPolyline *))completionHandler
{
    
    
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
    
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     
                                                     if(error)
                                                     {
                                                         if(completionHandler)
                                                             completionHandler(nil, nil);
                                                         return;
                                                     }
                                                     
                                                     NSArray *routesArray = [json objectForKey:@"routes"];
                                                     
                                                     GMSPolyline *polyline = nil;
                                                     
                                                     if ([routesArray count] > 0)
                                                     {
                                                         NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                         
                                                         
                                                         NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                         NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                         GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                         
                                                         polyline = [GMSPolyline polylineWithPath:path];
                                                         polyline.strokeWidth = 4.f;
                                                         
                                                         polyline.strokeColor = [UIColor blueColor];
                                                         
                                                     }
                                                     
                                                     if(completionHandler)
                                                         completionHandler(polyline, json);
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         if ([[json valueForKey:@"routes"] count]> 0)
                                                         {
                                                             if ([[[[json valueForKey:@"routes"] objectAtIndex:0] valueForKey:@"legs"] count]>0) {
                                                                 
                                                                 DistanseTimeLabel.text=[NSString stringWithFormat:@"Distance: %@ Time: %@",[[[[[[json valueForKey:@"routes"] objectAtIndex:0] valueForKey:@"legs"] objectAtIndex:0] valueForKey:@"distance"]valueForKey:@"text"],[[[[[[json valueForKey:@"routes"] objectAtIndex:0] valueForKey:@"legs"] objectAtIndex:0] valueForKey:@"duration"] valueForKey:@"text"]];
                                                                 
                                                                 [UIView animateWithDuration:0 animations:^{
                                                                     _DistanceInfoTop.constant=5;
                                                                     
                                                                 } completion:^(BOOL finished) {
                                                                     
                                                                 }];
                                                             }
                                                         }
                                                         
                                                     });
                                                     
                                                 }];
    [fetchDirectionsTask resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
