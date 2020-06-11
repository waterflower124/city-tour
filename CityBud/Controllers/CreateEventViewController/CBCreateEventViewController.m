//
//  CBCreateEventViewController.m
//  CityBud
//
//  Created by Ajay Chaudhary on 29/01/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBCreateEventViewController.h"
#import "CBSearchResultViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImageView+HighlightedWebCache.h>
#import "STMethod.h"

@interface CBCreateEventViewController (){
    CGFloat animatedDistance;
    UIDatePicker *datePicker, *timePicker1,
    *timePicker2;
    UIToolbar * keyboardToolBar;
    UITapGestureRecognizer *tapGesture;
}

@end

@implementation CBCreateEventViewController

+(BOOL)isEmpty:(NSString *)str
{
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str  isEqualToString:NULL]||[str isEqualToString:@"(null)"]||str==nil || [str isEqualToString:@"<null>"]){
        return YES;
    }
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [labelTitle setText:@"Create Event"];
    
    EventImagarray = [[NSMutableArray alloc]init];
    
    AppPhotosArray = [[NSMutableArray alloc]init];
    AppPhotos_id_Array = [[NSMutableArray alloc]init];
    
    RegularTicketDict = [[NSMutableDictionary alloc]init];
    VIPTicketDict = [[NSMutableDictionary alloc]init];
    VVIPTicketDict = [[NSMutableDictionary alloc]init];
    
//    PhotosCollectionView.collectionViewLayout = [[PhotosViewFlowLayout alloc] init];
//    PhotosCollectionView.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(220, 220)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [PhotosCollectionView setCollectionViewLayout:flowLayout];
    
    // Clear cache for testing
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    if (_editEvent){
        
        
        NSArray *arrimages  = _dicctEditEvent[@"images"];
    
        if (arrimages.count == 0) {
            
            NSArray *arrSearchEventPic = [_dicctEditEvent[@"event_pic"] componentsSeparatedByString:@","];
            NSMutableArray *img=[NSMutableArray new];
            NSMutableArray *arrImg = [NSMutableArray new];
            
            for (img in arrSearchEventPic) {
                NSLog(@"dictEventInfo slider image link is %@",img);
                [arrImg addObject:[NSString stringWithFormat:@"%@",img]];
                AppPhotosArray = [arrImg mutableCopy];
            }
            
        }else{
             Temparray = [[NSMutableArray alloc]init];
             NSMutableArray *arrImg = [NSMutableArray new];
             NSMutableArray *arrImgid = [NSMutableArray new];
            
            for (int i=0; i<arrimages.count; i++) {
                
                NSString *imageurlstr = [[_dicctEditEvent[@"images"] objectAtIndex:i] valueForKey:@"event_image"];
                
                NSString *imageurlstrid = [[_dicctEditEvent[@"images"] objectAtIndex:i] valueForKey:@"id"];
                
                [arrImg addObject:[NSString stringWithFormat:@"%@",imageurlstr]];
                
                [arrImgid addObject:[NSString stringWithFormat:@"%@",imageurlstrid]];
                
                Temparray = [arrImgid mutableCopy];
                AppPhotosArray = [arrImg mutableCopy];
            }
        }
        
        EventImagarray =[AppPhotosArray mutableCopy];
        
        NSUInteger count = [Temparray count]-1;
        
        for (int i=0; i<5; i++) {
            
            NSMutableDictionary *dic123 = [[NSMutableDictionary alloc] init];
            
            if (count >= i) {
                if ([STMethod stringIsEmptyOrNot:[Temparray objectAtIndex:i]] == true) {
                    
                    [dic123 setValue:@"" forKey:@"imageid"];
                    
                }else{
                    
                    [dic123 setValue:[NSString stringWithFormat:@"%@",[Temparray objectAtIndex:i]] forKey:@"imageid"];
                    
                }
            }else{
                [dic123 setValue:@"" forKey:@"imageid"];
            }
        
            [AppPhotos_id_Array addObject:dic123];
        }
        
        //AppPhotosArray
        [labelTitle setText:@"Update Event"];
        
        [buttonAddEvent setTitle:@"Update Event" forState:UIControlStateNormal];
        
        tfRNumberofTicket.text =_dicctEditEvent[@"ticket_number_regular"];
        tfVNumberofTicket.text =_dicctEditEvent[@"ticket_number_vip"];
        tfVVNumberofTicket.text =_dicctEditEvent[@"ticket_number_vvip"];
        
        tfRTicketPrice.text =_dicctEditEvent[@"ticket_price_regular"];
        tfVTicketPrice.text =_dicctEditEvent[@"ticket_price_vip"];
        tfVVTicketPrice.text =_dicctEditEvent[@"ticket_price_vvip"];
        
        RChechImg.image = [UIImage imageNamed:@"checkbox_filled"];
        tfRNumberofTicket.userInteractionEnabled = true;
        tfRTicketPrice.userInteractionEnabled = true;
        
        
        VCheckImg.image = [UIImage imageNamed:@"checkbox_filled"];
        tfVNumberofTicket.userInteractionEnabled = true;
        tfVTicketPrice.userInteractionEnabled = true;
        
        VVCheckImg.image = [UIImage imageNamed:@"checkbox_filled"];
        tfVVNumberofTicket.userInteractionEnabled = true;
        tfVVTicketPrice.userInteractionEnabled = true;
    }
    
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    tapGesture.enabled = true;
    
    cityArray = [NSArray arrayWithObjects:@"Calabar",@"Port Harcourt",@"Abuja",@"Owerri",@"Lagos", nil];
    categoryArray = [NSArray arrayWithObjects:@"NightLife", @"Education and Corporate", @"Sports and Fitness", @"Festivals and Concerts",@"Religious",@"Hotspots", nil];
    tfDate.tag = 103;
    tfStartTime.tag = 104;
    tfEndTime.tag = 105;
    
    tfCity.tag = 101;
    tfCategory.tag = 102;
    
    if (_editEvent){
        
        if([_dicctEditEvent[@"event_pic"] isEqualToString:@""]){
            
            imageViewChooseImage.image = [UIImage imageNamed:@"logo_small"];
        }else{
            
            NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:_dicctEditEvent[@"event_pic"]]];
            [imageViewChooseImage setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"logo_small"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                imageViewChooseImage.image = image;
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                imageViewChooseImage.image = [UIImage imageNamed:@"logo_small"];
            }];
            
            
            //imageViewChooseImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_dicctEditEvent[@"event_pic"]]]];
        }
        
        tfEventName.text = _dicctEditEvent[@"event_name"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];   // EEEE MMM-dd HH:mm a
        
        NSString *dateString =[[_dicctEditEvent[@"event_date"] componentsSeparatedByString:@" "] objectAtIndex:0];
        
        //  NSDate *date = [dateFormatter dateFromString:_dicctEditEvent[@"event_date"]];
        //        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //        NSString *showDate = [dateFormatter1 stringFromDate:date];
        tfDate.text = dateString;
        
        tfStartTime.text = _dicctEditEvent[@"event_time"];
        tfEndTime.text = _dicctEditEvent[@"event_endtime"];
        tfVenueName.text = _dicctEditEvent[@"event_venue"];
        tfAddress.text = _dicctEditEvent[@"event_address"];
        tfCity.text = _dicctEditEvent[@"event_city"];
        tfCategory.text = _dicctEditEvent[@"category"];
        tvDiscription.text = _dicctEditEvent[@"event_description"];
        tfWebsite.text=_dicctEditEvent[@"siteurl"];
        tfPhoneNumber.text=_dicctEditEvent[@"phone"];
        
        NSString *latstr= [NSString stringWithFormat:@"%@",_dicctEditEvent[@"lat"]];
        
        NSString *longstr= [NSString stringWithFormat:@"%@",_dicctEditEvent[@"long"]];
        
        if ([STMethod stringIsEmptyOrNot:latstr] == false && [STMethod stringIsEmptyOrNot:longstr] == false) {
            
            Addresslatstr = [NSString stringWithFormat:@"%@",_dicctEditEvent[@"lat"]];
            Addresslongstr = [NSString stringWithFormat:@"%@",_dicctEditEvent[@"long"]];
            
        }else {
            
            if ([STMethod stringIsEmptyOrNot:tfAddress.text] == false) {
                
                double latitude = 0, longitude = 0;
                
                NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
                NSString *esc_addr = [tfAddress.text stringByAddingPercentEncodingWithAllowedCharacters:set];
                
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

                
                
                if (center.latitude == 0.000000 && center.longitude==0.000000) {
                    
                    Addresslatstr = [NSString stringWithFormat:@"0000000"];
                    Addresslongstr = [NSString stringWithFormat:@"0000000"];
                    
                }else{
                   
                    Addresslatstr = [NSString stringWithFormat:@"%f",center.latitude];
                    Addresslongstr = [NSString stringWithFormat:@"%f",center.longitude];
                    
                }
            }
        }
        
        
        
                datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,50,100,216)];
                [datePicker addTarget:self action:@selector(datePickerChanged:)  forControlEvents:UIControlEventValueChanged];
                datePicker.datePickerMode  =  UIDatePickerModeDate;
                datePicker.backgroundColor = [UIColor whiteColor];
                tfDate.inputView           =  datePicker;
                [datePicker setMinimumDate:[NSDate date]];
                [self addToolBar:tfDate];
        
                timePicker1   = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,50,100,216)];
                [timePicker1 addTarget:self action:@selector(timePickerChanged1:)  forControlEvents:UIControlEventValueChanged];
                timePicker1.datePickerMode  =  UIDatePickerModeTime;
                timePicker1.backgroundColor = [UIColor whiteColor];
                tfStartTime.inputView           = timePicker1;
                [self addToolBar:tfStartTime];
        
        
        
    }else{
        
    }
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,50,100,216)];
    datePicker.tag = 103;
    [datePicker addTarget:self action:@selector(datePickerChanged:)  forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode  =  UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    tfDate.inputView =  datePicker;
    [datePicker setMinimumDate:[NSDate date]];
    [self addToolBar:tfDate];
    
    timePicker1   = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,50,100,216)];
    [timePicker1 addTarget:self action:@selector(timePickerChanged1:)  forControlEvents:UIControlEventValueChanged];
    timePicker1.tag = 104;
    timePicker1.datePickerMode  =  UIDatePickerModeTime;
    timePicker1.backgroundColor = [UIColor whiteColor];
    tfStartTime.inputView           = timePicker1;
    [self addToolBar:tfStartTime];
    
    timePicker2   = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,50,100,216)];
    [timePicker2 addTarget:self action:@selector(timePickerChanged2:)  forControlEvents:UIControlEventValueChanged];
    timePicker2.tag = 105;
    timePicker2.datePickerMode  =  UIDatePickerModeTime;
    timePicker2.backgroundColor = [UIColor whiteColor];
    tfEndTime.inputView           = timePicker2;
    [self addToolBar:tfEndTime];
    
    cityPicker  = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 216)];
    [cityPicker setTag:101];
    [cityPicker setDataSource: self];
    [cityPicker setDelegate: self];
    cityPicker.backgroundColor = [UIColor whiteColor];
    cityPicker.tintColor = [UIColor colorWithRed:0.11 green:0.31 blue:0.51 alpha:1.0];
    cityPicker.showsSelectionIndicator = YES;
    tfCity.inputView  =  cityPicker;
    [self addToolBar:tfCity];
    
    
    categoryPicker  = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 216)];
    [categoryPicker setTag:102];
    [categoryPicker setDataSource: self];
    [categoryPicker setDelegate: self];
    categoryPicker.backgroundColor = [UIColor whiteColor];
    categoryPicker.tintColor = [UIColor colorWithRed:0.11 green:0.31 blue:0.51 alpha:1.0];
    categoryPicker.showsSelectionIndicator = YES;
    tfCategory.inputView  =  categoryPicker;
    [self addToolBar:tfCategory];
    
    
    
    #pragma mark - google location search
    
    [tfAddress addTarget:self action:@selector(textFieldpressedaction:) forControlEvents:UIControlEventEditingDidBegin];
    
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    tfAddress.inputView = dummyView;
}


#pragma mark - google location search

- (void)textFieldpressedaction:(UITextField *)textField
{
    // Execute additional code
    
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    GMSAutocompleteFilter *filter=[[GMSAutocompleteFilter alloc]init];
    [filter setCountry:@"NGA"];
    acController.autocompleteFilter=filter;
    [self presentViewController:acController animated:YES completion:nil];
}


// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place %@", place);
    NSLog(@"Place latitude %f", place.coordinate.latitude);
    NSLog(@"Place longitude %f", place.coordinate.longitude);
    
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    Addresslatstr = [NSString stringWithFormat:@"%f",place.coordinate.latitude];
    Addresslongstr = [NSString stringWithFormat:@"%f",place.coordinate.longitude];
    
    tfAddress.text = [NSString stringWithFormat:@"%@",place.formattedAddress];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


#pragma mark - google location End

#pragma mark DatePicker Done Button

-(void) addToolBar : (UITextField *) _textField {
    keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.layer.frame.size.width, 40)];
    keyboardToolBar.barStyle = UIBarStyleDefault;
    
    keyboardToolBar.backgroundColor=[UIColor lightGrayColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor colorWithRed:0.16 green:0.38 blue:0.56 alpha:1.0],UITextAttributeTextColor,
                                nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(actionToolBarDone)];
    keyboardToolBar.tag = _textField.tag;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                done
                                ,
                                nil]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
    
    _textField.inputAccessoryView = keyboardToolBar;
}

#pragma mark - TextField Delegates


-(void)actionToolBarDone{
    
    [self.view endEditing:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == tfEventName || textField == tfVenueName || textField == tfAddress || textField == tfWebsite) {
        
        // do not allow the first character to be space | do not allow more than one space
        if ([string isEqualToString:@" "]) {
            if (!textField.text.length)
                return NO;
            if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
                return NO;
        }
        
        // allow backspace
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length < textField.text.length) {
            return YES;
        }
        
        // in case you need to limit the max number of characters
        //        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 30) {
        //            return NO;
        //        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()-+_= "];
        
        if ([string rangeOfCharacterFromSet:set].location == NSNotFound) {
            return NO;
        }
        
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if (textView == tvDiscription){
        // do not allow the first character to be space | do not allow more than one space
        if ([text isEqualToString:@" "]) {
            if (!textView.text.length)
                return NO;
            if ([[textView.text stringByReplacingCharactersInRange:range withString:text] rangeOfString:@"  "].length)
                return NO;
        }
        
        // allow backspace
        if ([textView.text stringByReplacingCharactersInRange:range withString:text].length < textView.text.length) {
            return YES;
        }
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()-+_= "];
        
        if ([text rangeOfCharacterFromSet:set].location == NSNotFound) {
            return NO;
        }        
        
    }
    return YES;
    //    if ([text rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
    //        return NO;
    //    }
    //    return YES;
}

#pragma mark - Date and Time Picker
- (void)datePickerChanged:(UIDatePicker *)picker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];   // EEEE MMM-dd HH:mm a
    
    NSString *showDate = [dateFormatter stringFromDate:picker.date];
    tfDate.text = showDate;
    
}
- (void)timePickerChanged1:(UIDatePicker *)picker
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];   // EEEE MMM-dd HH:mm a
    
    NSString *showTime = [dateFormatter stringFromDate:picker.date];
    tfStartTime.text = showTime;
}
- (void)timePickerChanged2:(UIDatePicker *)picker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];   // EEEE MMM-dd HH:mm a
    
    NSString *showTime = [dateFormatter stringFromDate:picker.date];
    tfEndTime.text = showTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonBackClicked:(UIButton *)sender {
    
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{ }];
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40; //self.rowHeight;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        return [cityArray count];
    }else{
        return [categoryArray count];
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView.tag == 101) {
        return cityArray[row];
    }else{
        return categoryArray[row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        tfCity.text = [cityArray objectAtIndex:row];
    }else{
        tfCategory.text = [categoryArray objectAtIndex:row];
    }
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UIView *vew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 40)];
    
    UILabel *picLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, vew.frame.size.width, 40)];
    
    picLB.font = FONT_Regular(16);
    picLB.textAlignment = NSTextAlignmentCenter;
    
    if(pickerView.tag == 101){
        picLB.text = [cityArray objectAtIndex:row];
    }else{
        picLB.text = [categoryArray objectAtIndex:row];
    }
    
    [vew addSubview:picLB];
    
    return vew;
    
}


#pragma mark - Action AddEvent
- (IBAction)actionAddEvent:(UIButton *)sender {
    // check validation and cal api
    [self hideKeyboard];
    
    if (![self checkValidation]){
        
        return;
    }else{
        if ([AFNetworkReachabilityManager sharedManager].reachable){
            SHOW_NETWORK_ERROR_ALERT();
            return;
        }else{
            //Implement webservice
            if(_editEvent){
                [self callUpdateEventWebservice];
            }else
            {
                if ([RChechImg.image isEqual:[UIImage imageNamed:@"checkbox_blank"]] && [VCheckImg.image isEqual:[UIImage imageNamed:@"checkbox_blank"]] && [VVCheckImg.image isEqual:[UIImage imageNamed:@"checkbox_blank"]])
                {
                    [STMethod showAlert:self Title:appNAME Message:@"Please select atleast one ticket type" ButtonTitle:@"Okay"];
                    return;
                }
                else
                {
                    // regular ticket
                    if ([RChechImg.image isEqual:[UIImage imageNamed:@"checkbox_filled"]])
                    {
                        if ([tfRNumberofTicket.text isEqualToString:@"0"] || [STMethod stringIsEmptyOrNot:tfRNumberofTicket.text])
                        {
                            [STMethod showAlert:self
                                          Title:appNAME Message:@"Enter number of ticket for Regular type" ButtonTitle:@"Okay"];
                            return;
                        }
                        else if ([tfRTicketPrice.text isEqualToString:@"0"] || [STMethod stringIsEmptyOrNot:tfRTicketPrice.text])
                        {
                            [STMethod showAlert:self
                                          Title:appNAME Message:@"Enter price of ticket for Regular type" ButtonTitle:@"Okay"];
                            return;
                        }
                        else
                        {
                            [RegularTicketDict setValue:@"yes" forKey:@"ticket_type_regular"];
                            [RegularTicketDict  setValue:tfRNumberofTicket.text forKey:@"ticket_number_regular"];
                            [RegularTicketDict setValue:tfRTicketPrice.text forKey:@"ticket_price_regular"];
                        }
                    }
                    else
                    {
                        [RegularTicketDict setValue:@"" forKey:@"ticket_type_regular"];
                        [RegularTicketDict  setValue:@"0" forKey:@"ticket_number_regular"];
                        [RegularTicketDict setValue:@"0" forKey:@"ticket_price_regular"];
                    }
                    
                    // vip ticket
                    if ([VCheckImg.image isEqual:[UIImage imageNamed:@"checkbox_filled"]])
                    {
                        if ([tfVNumberofTicket.text isEqualToString:@"0"] || [STMethod stringIsEmptyOrNot:tfVNumberofTicket.text])
                        {
                            [STMethod showAlert:self
                                          Title:appNAME Message:@"Enter number of ticket for VIP type" ButtonTitle:@"Okay"];
                            return;
                        }
                        else if ([tfVTicketPrice.text isEqualToString:@"0"] || [STMethod stringIsEmptyOrNot:tfVTicketPrice.text])
                        {
                            [STMethod showAlert:self
                                          Title:appNAME Message:@"Enter price of ticket for VIP type" ButtonTitle:@"Okay"];
                            return;
                        }
                        else
                        {
                            [VIPTicketDict setValue:@"yes" forKey:@"ticket_type_vip"];
                            [VIPTicketDict  setValue:tfVNumberofTicket.text forKey:@"ticket_number_vip"];
                            [VIPTicketDict setValue:tfVTicketPrice.text forKey:@"ticket_price_vip"];
                        }
                    }
                    else
                    {
                        [VIPTicketDict setValue:@"" forKey:@"ticket_type_vip"];
                        [VIPTicketDict  setValue:@"0" forKey:@"ticket_number_vip"];
                        [VIPTicketDict setValue:@"0" forKey:@"ticket_price_vip"];
                        
                    }
                    
                    // vvip ticket
                    if ([VVCheckImg.image isEqual:[UIImage imageNamed:@"checkbox_filled"]])
                    {
                        if ([tfVVNumberofTicket.text isEqualToString:@"0"] || [STMethod stringIsEmptyOrNot:tfVVNumberofTicket.text])
                        {
                            [STMethod showAlert:self
                                          Title:appNAME Message:@"Enter number of ticket for VVIP type" ButtonTitle:@"Okay"];
                            return;
                        }
                        else if ([tfVVTicketPrice.text isEqualToString:@"0"] || [STMethod stringIsEmptyOrNot:tfVVTicketPrice.text])
                        {
                            [STMethod showAlert:self
                                          Title:appNAME Message:@"Enter price of ticket for VVIP type" ButtonTitle:@"Okay"];
                            return;
                        }
                        else
                        {
                            [VVIPTicketDict setValue:@"yes" forKey:@"ticket_type_vvip"];
                            [VVIPTicketDict  setValue:tfVVNumberofTicket.text forKey:@"ticket_number_vvip"];
                            [VVIPTicketDict setValue:tfVVTicketPrice.text forKey:@"ticket_price_vvip"];
                        }
                    }
                    else
                    {
                        [VVIPTicketDict setValue:@"" forKey:@"ticket_type_vvip"];
                        [VVIPTicketDict  setValue:@"0" forKey:@"ticket_number_vvip"];
                        [VVIPTicketDict setValue:@"0"forKey:@"ticket_price_vvip"];
                    }
                }
            }
            NSLog(@"%@ %@ %@", RegularTicketDict, VIPTicketDict, VVIPTicketDict);
            
            [self callAddEventWebservice];
        }
    }
}

//-(BOOL) isEmptyString : (NSString *)string
//{
//    if([string length] == 0 || [string isKindOfClass:[NSNull class]] ||
//       [string isEqualToString:@""]||[string  isEqualToString:NULL]  ||
//       string == nil)
//    {
//        return YES;         //IF String Is An Empty String
//    }
//    return NO;
//}

//TODO: call webservice

- (void)callUpdateEventWebservice{
    
    
    
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"UpdateEvent.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.shouldShowLoadingActivity = YES;
    
    
    inputParam.dictPostParameters = [@{@"event_id" : _dicctEditEvent[@"id"],
                                       @"user_id"  : [USUserInfoModel sharedInstance].user_id,
                                       @"category" : tfCategory.text,
                                       @"event_city" : tfCity.text,
                                       @"event_date" : tfDate.text,
                                       @"event_time": tfStartTime.text,
                                       @"event_endtime": tfEndTime.text,
                                       @"event_venue": tfVenueName.text,
                                       @"event_address": tfAddress.text,
                                       @"event_name": tfEventName.text,
                                       @"event_description": tvDiscription.text,
                                       @"siteurl":tfWebsite.text,
                                       @"lat":Addresslatstr,
                                       @"long":Addresslongstr,
                                       @"presale":@"0",
                                       @"phone":tfPhoneNumber.text,
                                       @"event_pic_id1":[[AppPhotos_id_Array objectAtIndex:0] valueForKey:@"imageid"],
                                       @"event_pic_id2":[[AppPhotos_id_Array objectAtIndex:1] valueForKey:@"imageid"],
                                       @"event_pic_id3":[[AppPhotos_id_Array objectAtIndex:2] valueForKey:@"imageid"],
                                       @"event_pic_id4":[[AppPhotos_id_Array objectAtIndex:3] valueForKey:@"imageid"],
                                       @"event_pic_id5":[[AppPhotos_id_Array objectAtIndex:4] valueForKey:@"imageid"]
                                       } mutableCopy];
    
    

    [inputParam.dictPostParameters setValue:@"yes" forKey:@"ticket_type_regular"];
    [inputParam.dictPostParameters setValue:tfRTicketPrice.text forKey:@"ticket_price_regular"];
    [inputParam.dictPostParameters setValue:tfRNumberofTicket.text forKey:@"ticket_number_regular"];
    
    [inputParam.dictPostParameters setValue:@"yes" forKey:@"ticket_type_vip"];
    [inputParam.dictPostParameters setValue: tfVNumberofTicket.text  forKey:@"ticket_number_vip"];
    [inputParam.dictPostParameters setValue:tfVTicketPrice.text forKey:@"ticket_price_vip"];
    
    
    [inputParam.dictPostParameters setValue:@"yes" forKey:@"ticket_type_vvip"];
    [inputParam.dictPostParameters setValue:tfVVNumberofTicket.text forKey:@"ticket_number_vvip"];
    [inputParam.dictPostParameters setValue:tfVVTicketPrice.text forKey:@"ticket_price_vvip"];
    

    
    //inputParam.arrayMedia = @[imageViewChooseImage.image];
    
    inputParam.arrayMedia = AppPhotosArray;
    
    [WDWebserviceHelper callMultiPartRequestWithInputParameter:inputParam mediaType:nil success:^(id response, NSError *error) {
        
        NSLog(@"Add Event Response==>%@",response);
        
        if([[response[@"status"] valueForKey:@"code"] isEqual:@"1"]){
            
            HIDE_LOADING();
            
            NSDictionary *dictResponse = response[@"body"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIAlertController showAlertWithTitle:appNAME message:@"Your event has been updated successfully. It would be shown  as soon as the administrator approves it." onViewController:self];
                [self.navigationController popViewControllerAnimated:YES];
                
                CBSearchResultViewController *searchResultVC = [CBSearchResultViewController alloc];
                [searchResultVC.arrSearchResult replaceObjectAtIndex:_editIndex withObject:dictResponse];
            });
            
        }else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                HIDE_LOADING();
                [UIAlertController showAlertWithTitle:appNAME message:[response[@"status"] valueForKey:@"message"] onViewController:self];
            });
        }
    } error:^(id reponse, NSError *error) {
        HIDE_LOADING();
        NSLog(@"%@",error.userInfo);
    }];
}



-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result)
    {
        NSLog(@"Lat Long Result :: %@",result);
        
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
    return center;
    
}

- (void)callAddEventWebservice
{
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    inputParam.webserviceRelativePath = @"AddEvent.php";
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    inputParam.shouldShowLoadingActivity = YES;
    
    
    NSString *AddressString=[NSString stringWithFormat:@"%@ %@ %@",tfVenueName.text,tfAddress.text,tfCity.text];
    
    CLLocationCoordinate2D VenueLocation=[self getLocationFromAddressString:AddressString];
    
    if (VenueLocation.longitude==0.000000 &&  VenueLocation.latitude==0.000000)
    {
        VenueLocation=[self getLocationFromAddressString:tfCity.text];
    }
    
    inputParam.dictPostParameters = [@{
                                       @"user_id" : [USUserInfoModel sharedInstance].user_id,
                                       @"category" : tfCategory.text,
                                       @"event_city" : tfCity.text,
                                       @"event_date" : tfDate.text,
                                       @"event_time": tfStartTime.text,
                                       @"event_endtime": tfEndTime.text,
                                       @"event_venue": tfVenueName.text,
                                       @"event_address": tfAddress.text,
                                       @"event_name": tfEventName.text,
                                       @"event_description": tvDiscription.text,
                                       @"siteurl":tfWebsite.text,
                                       @"phone":tfPhoneNumber.text,
                                       @"lat":[NSString stringWithFormat:@"%f",VenueLocation.latitude],
                                       @"long":[NSString stringWithFormat:@"%f",VenueLocation.longitude],
                                       @"lat":Addresslatstr,
                                       @"long":Addresslongstr,
                                       @"presale":@"0",
                                       
                                       } mutableCopy];
    
   // NSLog(@"Add Event Response==>%@",inputParam.dictPostParameters);
    
    
    [inputParam.dictPostParameters setValue:[RegularTicketDict valueForKey:@"ticket_type_regular"] forKey:@"ticket_type_regular"];
    [inputParam.dictPostParameters setValue:[RegularTicketDict valueForKey:@"ticket_price_regular"] forKey:@"ticket_price_regular"];
    [inputParam.dictPostParameters setValue:[RegularTicketDict valueForKey:@"ticket_number_regular"] forKey:@"ticket_number_regular"];
    
    [inputParam.dictPostParameters setValue:[VIPTicketDict valueForKey:@"ticket_type_vip"] forKey:@"ticket_type_vip"];
    [inputParam.dictPostParameters setValue:[VIPTicketDict valueForKey:@"ticket_number_vip"] forKey:@"ticket_number_vip"];
    [inputParam.dictPostParameters setValue:[VIPTicketDict valueForKey:@"ticket_price_vip"] forKey:@"ticket_price_vip"];
    
    
    [inputParam.dictPostParameters setValue:[VVIPTicketDict valueForKey:@"ticket_type_vvip"] forKey:@"ticket_type_vvip"];
    [inputParam.dictPostParameters setValue:[VVIPTicketDict valueForKey:@"ticket_number_vvip"] forKey:@"ticket_number_vvip"];
    [inputParam.dictPostParameters setValue:[VVIPTicketDict valueForKey:@"ticket_price_vvip"] forKey:@"ticket_price_vvip"];
    
    //lat
    
    //long
    
    NSLog(@"All parameters for add events : %@",inputParam.dictPostParameters);
    
    
    //inputParam.arrayMedia = @[imageViewChooseImage.image];
    inputParam.arrayMedia = AppPhotosArray;
    
    [WDWebserviceHelper callMultiPartRequestWithInputParameter:inputParam mediaType:nil success:^(id response, NSError *error) {
        
        NSLog(@"Add Event Response==>%@",response);
        
        if([[response[@"status"] valueForKey:@"code"] isEqual:@"1"]){
            
            HIDE_LOADING();
            
            NSDictionary *dictResponse = response[@"body"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIAlertController showAlertWithTitle:appNAME message:@"Your event has been created successfully. It would be shown  as soon as the administrator approves it." onViewController:self];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_all_events" object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                /*
                 CBSearchResultViewController *searchResultVC = [CBSearchResultViewController alloc];
                 if(_editEvent){
                 [searchResultVC.arrSearchResult replaceObjectAtIndex:_editIndex withObject:dictResponse];
                 }else{
                 [searchResultVC.arrSearchResult addObject:dictResponse];
                 }*/
                
                
                
                
                //                [self performSegueWithIdentifier:@"" sender:nil];
            });
            
        }else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIAlertController showAlertWithTitle:appNAME message:[response[@"status"] valueForKey:@"message"] onViewController:self];
            });
        }
    } error:^(id reponse, NSError *error) {
        
        NSLog(@"%@",error.userInfo);
    }];
}

#pragma mark - action choose image
- (IBAction)actionChooseImage:(UIButton *)sender {
    
    
}

#pragma mark - Private methods

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

- (BOOL)checkValidation {
    NSString *urlRegEx = @"(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/?)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))*(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’])*)";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    
    NSString *phoneRegex = @"^[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    if (imageViewChooseImage.image == nil){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please choose an image." onViewController:self];
        return NO;
    }else if ([tfEventName.text length] == 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter event name." onViewController:self];
        return NO;
    }else if ([tfDate.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter date." onViewController:self];
        return NO;
    }else if ([tfStartTime.text length]== 0 ){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter start time" onViewController:self];
        return NO;
    }else if ([tfEndTime.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter end time" onViewController:self];
        return NO;
    }else if ([tfVenueName.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter venue." onViewController:self];
        return NO;
    }else if ([tfAddress.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter address." onViewController:self];
        return NO;
    }else if ([tfCity.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please select city." onViewController:self];
        return NO;
    }else if ([tfCategory.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please select category." onViewController:self];
        return NO;
    }else if ([tvDiscription.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter description." onViewController:self];
        return NO;
    }else if ([tfWebsite.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter website." onViewController:self];
        return NO;
    }else if (![urlTest evaluateWithObject:tfWebsite.text]){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter valid website." onViewController:self];
        return NO;
    }else if ([tfPhoneNumber.text length]== 0){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter phone number." onViewController:self];
        return NO;
    }else if (![phoneTest evaluateWithObject:tfPhoneNumber.text]){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please enter valid phone number." onViewController:self];
        return NO;
    }
    
    return YES;
}

- (void)showCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover presentPopoverFromBarButtonItem:imageBtn
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

- (void)openPhotoAlbum{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:controller animated:YES completion:NULL];
    
}
#pragma mark - UIImagePickerControllerDelegate methods
/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    CGRect rect = CGRectMake(0,0,600,400);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageViewChooseImage.image = picture1;
    
    if(_editEvent){ // Monday 16 Apr 2018
        
        NSUInteger count = [EventImagarray count]-1;
        
        if (count >= updateeventimgeIndex) {
            
            [EventImagarray replaceObjectAtIndex:updateeventimgeIndex withObject:imageViewChooseImage.image];
            
        }else{
            [EventImagarray addObject:imageViewChooseImage.image];
        }
        

    }else
    {
        if (AppPhotosArray.count ==5) {
            
            [EventImagarray replaceObjectAtIndex:updateeventimgeIndex withObject:imageViewChooseImage.image];
            
        }else{
            
             [EventImagarray addObject:imageViewChooseImage.image];
            
        }
    }
   
    AppPhotosArray = [EventImagarray mutableCopy];
    
    [PhotosCollectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Regular button click
- (IBAction)Regular_ticket_button:(UIButton *)sender {
    
    if ([RChechImg.image isEqual:[UIImage imageNamed:@"checkbox_blank"]])
    {
        RChechImg.image = [UIImage imageNamed:@"checkbox_filled"];
        tfRNumberofTicket.userInteractionEnabled = true;
        tfRTicketPrice.userInteractionEnabled = true;
    }
    else
    {
        RChechImg.image = [UIImage imageNamed:@"checkbox_blank"];
        tfRNumberofTicket.userInteractionEnabled = false;
        tfRTicketPrice.userInteractionEnabled = false;
        tfRTicketPrice.text = @"0";
        tfRNumberofTicket.text = @"0";
    }
}

#pragma mark - VIP button click
- (IBAction)VIP_ticket_button_click:(UIButton *)sender {
    if ([VCheckImg.image isEqual:[UIImage imageNamed:@"checkbox_blank"]])
    {
        VCheckImg.image = [UIImage imageNamed:@"checkbox_filled"];
        tfVNumberofTicket.userInteractionEnabled = true;
        tfVTicketPrice.userInteractionEnabled = true;
    }
    else
    {
        VCheckImg.image = [UIImage imageNamed:@"checkbox_blank"];
        tfVNumberofTicket.userInteractionEnabled = false;
        tfVTicketPrice.userInteractionEnabled = false;
        tfVTicketPrice.text = @"0";
        tfVNumberofTicket.text = @"0";
    }
}

#pragma mark - VVIP button click
- (IBAction)VVIP_ticket_button_click:(UIButton *)sender {
    
    if ([VVCheckImg.image isEqual:[UIImage imageNamed:@"checkbox_blank"]])
    {
        VVCheckImg.image = [UIImage imageNamed:@"checkbox_filled"];
        tfVVNumberofTicket.userInteractionEnabled = true;
        tfVVTicketPrice.userInteractionEnabled = true;
    }
    else
    {
        VVCheckImg.image = [UIImage imageNamed:@"checkbox_blank"];
        tfVVNumberofTicket.userInteractionEnabled = false;
        tfVVTicketPrice.userInteractionEnabled = false;
        tfVVNumberofTicket.text = @"0";
        tfVVTicketPrice.text = @"0";
    }
}


#pragma mark - COLLECTIONVIEW
#pragma mark Collection View CODE

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_editEvent)
    {
        if (AppPhotosArray.count < 5) {
          
            return AppPhotosArray.count +1;
            
        }else if (AppPhotosArray.count == 5) {
            
             return AppPhotosArray.count;
        }
        else{
             return AppPhotosArray.count;
        }
    }else{
        if (AppPhotosArray.count==0) {
            
            return 1;
        }else{
            
            if (AppPhotosArray.count == 5)
            {
                return 5;
            }
            else
            {
                return AppPhotosArray.count +1;
            }
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CBPhotoCollectionViewCell *cell = [PhotosCollectionView dequeueReusableCellWithReuseIdentifier:@"CBPhotoCollectionViewCell" forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [PhotosCollectionView dequeueReusableCellWithReuseIdentifier:@"CBPhotoCollectionViewCell" forIndexPath:indexPath];
    }
    
    if (AppPhotosArray.count == 0)
    {
        
    }else
    {
        
        if (_editEvent)
        {
            
            if (indexPath.row > AppPhotosArray.count-1)
            {
                
            }else{
                
                NSObject * dataObj = [AppPhotosArray objectAtIndex:indexPath.row];
                
                if ([dataObj isKindOfClass:[UIImage class]])
                {
                    UIImage * image = (UIImage *) dataObj;
                    cell.Eventphoto.image  = image;
                    
                } else if ([dataObj isKindOfClass:[NSString class]]) {
                    
                    NSString * imageName = (NSString *) dataObj;
                    
                    //NSString * imageName = [NSString stringWithFormat:@"%@",[[AppPhotosArray objectAtIndex:indexPath.row] valueForKey:@"image"]];
                    
                    if ([imageName containsString:@"http"]){
                        // check is string is a url? by checking if it contains http
                        
                        imageName = [imageName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                        
                        NSURL *photourlCell = [NSURL URLWithString:imageName];
                        
                        [cell.Eventphoto sd_setImageWithURL:photourlCell placeholderImage:[UIImage imageNamed:@"AppIcon"] completed:nil];
                        
                    }else{
                        cell.Eventphoto.image = [UIImage imageNamed:imageName];
                    }
                    
                } else if ([dataObj isKindOfClass:[NSURL class]]) {
                    
                    NSURL *photourlCell = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[AppPhotosArray objectAtIndex:indexPath.row] valueForKey:@"image"]]];
                    
                    [cell.Eventphoto sd_setImageWithURL:photourlCell placeholderImage:[UIImage imageNamed:@"AppIcon"] completed:nil];
                    
                } else {
                    [NSException raise:@"Invalid type" format:@"KASlideShow only allow Array of UIImage, NSString/URL as string or NSURL"];
                }
            }
            

            
            cell.backgroundColor=[UIColor clearColor];
            
        }else{
            
            if (indexPath.row > AppPhotosArray.count-1)
            {
               
            }
            else
            {
                cell.Eventphoto.image = [AppPhotosArray objectAtIndex:indexPath.row];
                cell.backgroundColor=[UIColor clearColor];
            }
            
        }
        cell.Eventphoto.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.Eventbtn.tag = indexPath.row;
        
    }
    return cell;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ((touch.view == PhotosCollectionView) || (touch.view == EventPhotoView)) {
        
        return NO;
    }
    
    return YES;
}



#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width / 4.0f;
    return CGSizeMake(picDimension, picDimension);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat leftRightInset = self.view.frame.size.width / 14.0f;
    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset);
}

// pragma mark Collection view layout things
// Layout: Set cell size

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}


-(IBAction)pressBtn:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    
    updateeventimgeIndex = [[NSString stringWithFormat:@"%ld",btn.tag] intValue];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:appNAME message:@"Upload Photo!" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * button0   = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        //  UIAlertController will automatically dismiss the view
    }];
    
    UIAlertAction * button1   = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController * imagePickerController= [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing= YES;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
        }else {
            
            [UIAlertController showAlertWithTitle:appNAME message:@"No Camera Availabel!!!" onViewController:self];
        }
    }];
    
    UIAlertAction * button2   = [UIAlertAction actionWithTitle:@"Choose Existing" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UIImagePickerController * imagePickerController= [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing= YES;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
