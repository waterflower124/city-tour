//
//  CBSearchViewController.m
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBSearchViewController.h"
#import "CBSearchResultViewController.h"
#import <LGAlertView/LGAlertView.h>
#import "STMethod.h"

@interface CBSearchViewController ()<LGAlertViewDelegate>
{
    
    NSArray *arrResponse;
    NSString *strCategory;
    NSMutableDictionary *dictSearchParams;
    UIDatePicker *datePicker;
}

@end

@implementation CBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    [tfSearchQuery addTarget:self action:@selector(SearchTestfieldStartToEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
     _SearchByDate = false;
    
    constraintsViewDD.constant = 0;
    if (IS_IPHONE4_OR_4S || IS_IPHONE5_OR_5S)
    {
        total_height.constant = 80;
    }
    else if (IS_IPHONE6 )
    {
        total_height.constant = 130;
    }
    else if (IS_IPHONE6pluse)
    {
        total_height.constant = 180;
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
    constraintsViewDD.constant = 0;   
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonMenuClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tesxfield start chages
-(IBAction)SearchTestfieldStartToEditing:(UITextField*)sender
{
    DateShow.text = nil;
    constraintsViewDD.constant = 0;
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - EVentTypeButton clicked
//TODO: button dropdown clicked

- (IBAction)buttonEventTypeClicked:(UIButton *)sender {
    [self hideKeyboard];
    if (sender.selected == YES) {
        [sender setSelected:NO];
        
        constraintsViewDD.constant = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        [sender setSelected:YES];
        constraintsViewDD.constant = 217;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)buttonEventSelectClicked:(UIButton *)sender {
    [self hideKeyboard];
    constraintsViewDD.constant = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [buttonCategory setSelected:NO];
    
    
    //NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"] mutableCopy];
    //[dict setObject:sender.titleLabel.text forKey:@"user_event_type"];
    //[USUserInfoModel sharedInstance].user_event_type = sender.titleLabel.text;
    
    //    strCategory = sender.titleLabel.text;
    //event", "restaurants", "bank", "HealthWellness", "movie", "veneus
    if([sender.titleLabel.text isEqualToString:@"Events"]){
        strCategory = @"event";
    }else if ([sender.titleLabel.text isEqualToString:@"Restaurants"]){
        strCategory = @"restaurants";
    }else if ([sender.titleLabel.text isEqualToString:@"Banks & ATMs"]){
        strCategory = @"bank";
    }else if ([sender.titleLabel.text isEqualToString:@"Health & Wellness"]){
        strCategory = @"HealthWellness";
    }else if ([sender.titleLabel.text isEqualToString:@"Movies"]){
        strCategory = @"movie";
    }else if ([sender.titleLabel.text isEqualToString:@"Religious"]){
        strCategory = @"religious";
    }
    else if ([sender.titleLabel.text isEqualToString:@"Hotspots"]){
        strCategory = @"hotspots";
    }
    
    if ([strCategory isEqualToString:@"event"] || [strCategory isEqualToString:@"movie"])
    {
        DateShow.hidden = false;
        CalenderButton.hidden = false;
        selectdatelbl.hidden = false;
        CalenderButton.userInteractionEnabled = true;
        category_height.constant = 87;
        calenderIcon.hidden = false;
    }
    else
    {
        DateShow.hidden = true;
        selectdatelbl.hidden = true;
        CalenderButton.hidden = true;
        CalenderButton.userInteractionEnabled = false;
        category_height.constant = 10;
        _SearchByDate = false;
        calenderIcon.hidden = true;
    }
    
    //[[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserInfo"];
    // [[NSUserDefaults standardUserDefaults] synchronize];
    
    [buttonCategory setTitle:sender.titleLabel.text forState:UIControlStateNormal];
}

#pragma mark - LocalMethods
//TODO: hide keyboard

-(void)hideKeyboard{
    
    [self.view endEditing:YES];
}

- (BOOL)checkValidation{
    if ([tfSearchQuery.text  isEqual: @""])
    {
        if ([strCategory isEqualToString:@"event"] || [strCategory isEqualToString:@"movie"]) {
            if ([STMethod stringIsEmptyOrNot:DateShow.text])
            {
                [UIAlertController showAlertWithTitle:appNAME message:@"Please enter search query!! or Just select a date !!!" onViewController:self];
                [tfSearchQuery becomeFirstResponder];
                return NO;
            }
        }
        else {
            [UIAlertController showAlertWithTitle:appNAME message:@"Please enter search query!!" onViewController:self];
            [tfSearchQuery becomeFirstResponder];
            return NO;
        }
    }else if ([buttonCategory.titleLabel.text isEqualToString:@"Category"]){
        [UIAlertController showAlertWithTitle:appNAME message:@"Please choose a category" onViewController:self];
        return NO;
    }
    return YES;
}

#pragma mark - ActionSearchClicked
- (IBAction)actionSearch:(UIButton *)sender {
    
    if (!([self checkValidation])){
        return;
    }
    
    if ([AFNetworkReachabilityManager sharedManager].isReachable){
        SHOW_NETWORK_ERROR_ALERT();
        return;
    }else{
        
        [self performSegueWithIdentifier:@"CBSearchResultViewController" sender:nil];
        
        //Search Webservice implementaiton
        /* http://socialbud.imvisile.com/api/users/Search.php
         // search_query
         // category
         */
    }
}

#pragma mark - Calender open button
- (IBAction)CalenderButtonClick:(UIButton *)sender {
    
    _SearchByDate = true;
    constraintsViewDD.constant = 0;
    
    datePicker = [UIDatePicker new];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = CGRectMake(0.0, 0.0, datePicker.frame.size.width, 120.0);
    
    [[[LGAlertView alloc] initWithViewAndTitle:@"CityBud"
                                       message:@"Select a date"
                                         style:LGAlertViewStyleAlert
                                          view:datePicker
                                  buttonTitles:@[@"Done"]
                             cancelButtonTitle:@"Cancel"
                        destructiveButtonTitle:nil
                                      delegate:self] showAnimated:YES completionHandler:nil];
}

#pragma mark - LGAlertViewDelegate

- (void)alertView:(LGAlertView *)alertView clickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title {
    
    tfSearchQuery.text = nil;
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"dd/MM/yyyy"];
    
    DateShow.text = [df stringFromDate:datePicker.date];
}

- (void)alertViewCancelled:(LGAlertView *)alertView {
    NSLog(@"cancel");
}

//CBSearchResultViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CBSearchResultViewController"]){
        CBSearchResultViewController *searchResultVC = segue.destinationViewController;
        //        eventTypeVC.arrSearchResult = [arrResponse mutableCopy];
        
        if (_SearchByDate == true)
        {
            
            NSString * tempDate = [STMethod dateStringFromString:[NSString stringWithFormat:@"%@",DateShow.text] destinationFormat:@"yyyy-MM-dd"];
            
            tempDate = [NSString stringWithFormat:@"%@ 00:00:00",tempDate];
            
            dictSearchParams = [@{ @"search_query" : tempDate,
                                   @"search_by" :strCategory,
                                   @"event_city" :[USUserInfoModel sharedInstance].user_city} mutableCopy];
            
            searchResultVC.SearchUsingDate = true;
        }
        else
        {
            dictSearchParams = [@{ @"search_query" : tfSearchQuery.text,
                                   @"search_by" :strCategory,
                                   @"event_city" :[USUserInfoModel sharedInstance].user_city} mutableCopy];

        }
        
        searchResultVC.dictSearchParameter = dictSearchParams;
        searchResultVC.eventType = buttonCategory.titleLabel.text;
        if([strCategory isEqualToString:@"veneus"]){
            searchResultVC.isVenue = YES;
        }
    }
}

@end
