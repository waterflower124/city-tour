//
//  CBCreateEventViewController.h
//  CityBud
//
//  Created by Ajay Chaudhary on 29/01/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PEPhotoCropEditor/PECropViewController.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <MapKit/MapKit.h>
#import "LocationTracker.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "PhotosViewFlowLayout.h"
#import "CBPhotoCollectionViewCell.h"


@interface CBCreateEventViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate,GMSAutocompleteViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>{
    
    
    __weak IBOutlet kzTextField *tfEventName;
    __weak IBOutlet kzTextField *tfDate;
    __weak IBOutlet kzTextField *tfStartTime;
    __weak IBOutlet kzTextField *tfEndTime;
    __weak IBOutlet kzTextField *tfVenueName;    
    __weak IBOutlet kzTextField *tfAddress;
    __weak IBOutlet kzTextField *tfCity;
    __weak IBOutlet kzTextField *tfCategory;
    
    __weak IBOutlet kzTextField *tfWebsite;
    __weak IBOutlet kzTextField *tfPhoneNumber;
    
    __weak IBOutlet UITextView *tvDiscription;
    __weak IBOutlet UIImageView *imageViewChooseImage;
    
    __weak IBOutlet UIButton *buttonAddEvent;
    __weak IBOutlet UIButton *imageBtn;
    __weak IBOutlet UILabel *labelTitle;
    
    UIPickerView *categoryPicker;
    UIPickerView *cityPicker;
    NSArray      *cityArray;
    NSArray      *categoryArray;
    
    IBOutlet UIButton * RCheckbtn;
    IBOutlet UIButton * VCheckbtn;
    IBOutlet UIButton * VVCheckbtn;
    
    IBOutlet kzTextField * tfRNumberofTicket;
    IBOutlet kzTextField * tfVNumberofTicket;
    IBOutlet kzTextField * tfVVNumberofTicket;
    
    IBOutlet kzTextField * tfRTicketPrice;
    IBOutlet kzTextField * tfVTicketPrice;
    IBOutlet kzTextField * tfVVTicketPrice;
    
    IBOutlet UIImageView * RChechImg;
    IBOutlet UIImageView * VCheckImg;
    IBOutlet UIImageView * VVCheckImg;
    
    NSMutableDictionary * RegularTicketDict;
    NSMutableDictionary * VIPTicketDict;
    NSMutableDictionary * VVIPTicketDict;
    
    
    NSString *Addresslatstr;
    NSString *Addresslongstr;

    NSMutableArray *EventImagarray;
    
    int updateeventimgeIndex;
    
    
    NSMutableArray *AppPhotosArray,*Temparray;
    NSMutableArray *AppPhotos_id_Array;
    IBOutlet UIView *EventPhotoView;
    IBOutlet UICollectionView *PhotosCollectionView;
    UICollectionViewFlowLayout *PhotosCollectionViewLayout;
}

@property (nonatomic) UIPopoverController *popover;
@property (readwrite) BOOL editEvent;

- (IBAction)actionChooseImage:(UIButton *)sender;
- (IBAction)actionAddEvent:(UIButton *)sender;

@property (nonatomic,strong) NSDictionary *dicctEditEvent;
@property (nonatomic) long editIndex;

- (void)textFieldpressedaction:(UITextField *)textField;

-(IBAction)pressBtn:(id)sender;

@end
