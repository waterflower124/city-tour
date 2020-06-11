//
//  CBHomeDetailsViewController.h
//  CityBud
//
//  Created by Ajay Chaudhary on 29/01/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "KASlideShow.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>


@interface CBHomeDetailsViewController : UIViewController<GMSMapViewDelegate, KASlideShowDelegate, KASlideShowDataSource, EKEventEditViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *labelDateHeightConstraint;
    
    __weak IBOutlet NSLayoutConstraint *labelTimeHeightConstraint;
    
    
    __weak IBOutlet UIView *viewHeader;
    __weak IBOutlet NSLayoutConstraint *constraintViewHeaderHeight;

    __weak IBOutlet NSLayoutConstraint *constraintImageViewTop;
    
    __weak IBOutlet UIImageView *imageViewEvent;
    __weak IBOutlet UILabel *labelEventDate;
    __weak IBOutlet UILabel *labelEventTime;
    
    __weak IBOutlet UILabel *labelDate;
    __weak IBOutlet UILabel *labelCityName;
    
    __weak IBOutlet UIView *containerView;
    
    __weak IBOutlet UILabel *labelEventDiscription;
    __weak IBOutlet UILabel *labelEventDiscription12;
    __weak IBOutlet UILabel *labelEventAddress;
    __weak IBOutlet UILabel *labelEventName;    
    __weak IBOutlet UILabel *labelTime;

    __weak IBOutlet KASlideShow *viewSlideShow;
    
    __weak IBOutlet UIScrollView *detailView;
    __weak IBOutlet UIButton *buttonUber;
    
    __weak IBOutlet UIScrollView *viewUber;
    __weak IBOutlet UIButton *buttonUber2;
    
    __weak IBOutlet UIButton *buttonPhoneNumber;
    
    __weak IBOutlet UIButton *buttonWebsite;
    __weak IBOutlet UIButton *buttonPhoneNumber2;
    __weak IBOutlet UIButton *buttonWebsite2;
    
    
    __weak IBOutlet UILabel *labelEventName2;
    __weak IBOutlet UILabel *labelEventVenue2;
    __weak IBOutlet UILabel *labelWorkingHours;
     IBOutlet UILabel * countLabel;
   
    __weak IBOutlet UIButton *buttonPay;
    __weak IBOutlet UIButton *buttonShare;
    
    __weak IBOutlet UIButton * peopleAttendingBtn;
    
    NSMutableDictionary * dictParam;
    
    UIPageControl *pageControl;
}

@property (nonatomic,retain)IBOutlet UIPageControl *pageControl;

-(IBAction)clickPageControl:(id)sender;

@property (strong, nonatomic) NSDictionary *dictEventInfo;

@property (strong, nonatomic) NSDictionary *dictEventInfo2;

@property (readwrite) BOOL isFromSearch;
@property (readwrite) BOOL isYourEvent;
@property (readwrite) BOOL isVenue;

@property (weak, nonatomic) NSString *cityName;

@property (weak, nonatomic) NSString *eventType;

@property (strong, nonatomic)  GMSMapView *mapContainerView;

@property (weak, nonatomic) IBOutlet UIView *viewForMap;


- (IBAction)getLocation:(UIButton *)sender;
- (IBAction)actionEventPhone:(UIButton *)sender;
- (IBAction)actionEventWeb:(UIButton *)sender;
- (IBAction)actionAddToCalander:(UIButton *)sender;
- (IBAction)actionEventUber:(UIButton *)sender;

@property (readwrite) BOOL showUberView;
- (IBAction)actionEventPhone2:(UIButton *)sender;
- (IBAction)actionEventWeb2:(UIButton *)sender;
- (IBAction)actionEventUber2:(UIButton *)sender;

- (IBAction)actionCalander:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightviewforiphon4;

@end
