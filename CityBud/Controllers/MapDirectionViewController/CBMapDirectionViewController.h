//
//  CBMapDirectionViewController.h
//  CityBud
//
//  Created by Mohit Garg on 13/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>


@interface CBMapDirectionViewController : UIViewController<GMSMapViewDelegate>
{

    __weak IBOutlet UILabel *labelEventName;

    IBOutlet UILabel * DistanseTimeLabel;
    
    NSString *currentAddressStr;
    NSString *destinationAddressStr;
    
}


@property IBOutlet NSLayoutConstraint *DistanceInfoTop;

@property  CLLocationDegrees DestinationLatitude;
@property  CLLocationDegrees DestinationLongitude;

@property (weak, nonatomic) IBOutlet UIView *viewForMap;

@property (strong, nonatomic) NSString *strEventName;


//@property (strong, nonatomic)  GMSMapView *mapContainerView;

@property (strong,nonatomic) NSString *fullAddress;

- (IBAction)actionBackButton:(UIButton *)sender;




@end
