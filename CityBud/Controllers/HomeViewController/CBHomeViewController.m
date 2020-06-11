//
//  CBHomeViewController.m
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBHomeViewController.h"
#import "CBEventsTableViewCell.h"
#import "CBPhotoFeedTableViewCell.h"
#import "CBHomeDetailsViewController.h"
//#import "CBPhotoGalleryViewController.h"
#import "CBGalleryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "STMethod.h"


@interface CBHomeViewController ()
{
    NSArray *arrayEvents, *arrayTempEvents;
    NSDictionary *dictEventInfo;
    NSString *user_City;
    NSString *typeName;
    
    BOOL boolThisWeek;
    BOOL isFeatured, isVenue;
    BOOL isPullRefresh;
    
    NSArray *arrayImage;
    NSArray *arrayGalleryNames;
    UIRefreshControl *refreshControl;
}
@end

@implementation CBHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    typeName = @"Events";
    _isEvent = YES;
    isFeatured = NO;
    isVenue = NO;
    
   
    labelUnderWeek.hidden = YES;
    labelUnderNearMe.hidden = NO;

    tableViewEvents.emptyDataSetSource = self;
    tableViewEvents.emptyDataSetDelegate = self;
    
    arrayImage = @[@"1.jpeg", @"2.jpeg", @"3.jpeg", @"4.jpeg", @"5.jpeg", @"6.jpeg"];
    arrayGalleryNames = @[@"Night Life at Calabar", @"Hangout @Abuja", @"New Year bash", @"Christmas Eve", @"V'tine day party", @"The para club"];
    [self updateAllEventsName];
    
    
    user_City = [USUserInfoModel sharedInstance].user_city;

    self.labelCityName.text = [USUserInfoModel sharedInstance].user_city;
    
 //   [buttonEventType setTitle:[USUserInfoModel sharedInstance].user_event_type forState:UIControlStateNormal]
    [buttonEventType setTitle:@"All Events" forState:UIControlStateNormal];
   // [self buttonEventSelectClicked:buttonAllEvents];
    
  //  [buttonEventType setTitle:[USUserInfoModel sharedInstance].user_event_type forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:MFSideMenuStateNotificationEvent object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuEventsStateNotification:) name:MFSideMenuStateNotificationEvent object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reload_all_events" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callAllEvent) name:@"reload_all_events" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullDownToRefresh) name:@"afterTicketPurchase" object:nil];
    
    constraintViewDropDown.constant = 0;

    [self callAllEvent];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [tableViewEvents addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(pullDownToRefresh) forControlEvents:UIControlEventValueChanged];
    
    /*
    if (![[USUserInfoModel sharedInstance].user_event_type isEqualToString:@"All Events"]) {

        NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"category == '%@'",[USUserInfoModel sharedInstance].user_event_type]];
        arrayEvents = [arrayEvents filteredArrayUsingPredicate:pred];
    }*/
    
}

- (void) updateAllEventsName {
    
//    if (!isPullRefresh)
    //{
        [buttonEventType setTitle:@"All Events" forState:UIControlStateNormal];
    //}

    [buttonAllEvents setTitle:@"All Events" forState:UIControlStateNormal];
    [buttonNightlife setTitle:@"NightLife" forState:UIControlStateNormal];
    [buttonEducation setTitle:@"Education and Corporate" forState:UIControlStateNormal];
    [buttonSports setTitle:@"Sports and Fitness" forState:UIControlStateNormal];
    [buttonFestivals setTitle:@"Festivals , Arts and Concerts" forState:UIControlStateNormal];
    [buttonReligious setTitle:@"Religious" forState:UIControlStateNormal];
}

-(void)pullDownToRefresh
{
    isPullRefresh = YES;
    HIDE_LOADING();
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:2]
                                                         forKey:@"eventType"];
    
    NSNotification *noti = [NSNotification notificationWithName:MFSideMenuStateNotificationEvent object:nil userInfo:userInfo];
    
    [self menuEventsStateNotification:noti];
}

-(void)viewDidAppear:(BOOL)animated {
    
    
    
    self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;

    constraintViewDropDown.constant = 0;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)menuEventsStateNotification:(NSNotification *)notification {
    
    NSDictionary *dict = [notification userInfo];
    
//@"Hotspots", @"Religious",
    
    
    NSNumber *number = dict[@"eventType"];
    
    if (number.integerValue == 2) {
        NSLog(@"CLOSED");
        
        self.labelCityName.text = [USUserInfoModel sharedInstance].user_city;

        if (![self.labelMenuSelectedName.text isEqualToString:@"Events"]) {
            _isEvent = NO;
            isFeatured = NO;
            isVenue = NO;
            
            [buttonEventType setTitle:[USUserInfoModel sharedInstance].user_event_type forState:UIControlStateNormal];
            [buttonEventType setSelected:NO];
            [self updateAllEventsName];
            constraintViewDropDown.constant = 0;

            self.viewTopTitles.hidden = NO;
//            _isEvent = FALSE;
            
            self.viewTopButtons.hidden = YES;

            constraintTableViewTop.constant = 0;
            viewDropDownTop.hidden = YES;
            
            //arrayEvents = nil;
            //[tableViewEvents reloadData];
            
            if ([self.labelMenuSelectedName.text isEqualToString:@"Restaurants"]){
                _photo = NO;
                _isEvent = NO;
                typeName = @"Restaurants";
                isFeatured = NO;
                isVenue = NO;
                /*http://socialbud.imvisile.com/api/users/dining.php
                 'event_city
                 */
                NSMutableDictionary *dictParams = [@{
                                                     @"event_city" : user_City
                                                     } mutableCopy];
                
                [self callMenuWebservice:@"dining.php" dictParams:dictParams];
                
            }else if ([self.labelMenuSelectedName.text isEqualToString:@"Hotspots"]){
                _photo = NO;
                _isEvent = NO;
                typeName = @"Hotspots";
                isFeatured = NO;
                isVenue = NO;
                /*http://socialbud.imvisile.com/api/users/dining.php
                 'event_city
                 */
                NSMutableDictionary *dictParams = [@{
                                                     @"event_city" : user_City
                                                     } mutableCopy];
                
                [self callMenuWebservice:@"hotspots.php" dictParams:dictParams];
                
            }else if ([self.labelMenuSelectedName.text isEqualToString:@"Religious"]){
                
                if (!isPullRefresh) {
                    [buttonEventType setTitle:@"All Categories" forState:UIControlStateNormal];
                }               [buttonAllEvents setTitle:@"All Categories" forState:UIControlStateNormal];
                [buttonNightlife setTitle:@"Mosques" forState:UIControlStateNormal];
                [buttonEducation setTitle:@"Churches" forState:UIControlStateNormal];
              //  constraintViewDropDown.constant = 122;
                constraintTableViewTop.constant = 62;
                viewDropDownTop.hidden = NO;
                
                
                _photo = NO;
                _isEvent = NO;
                typeName = @"Religious";
                isFeatured = NO;
                isVenue = NO;
                /*http://socialbud.imvisile.com/api/users/movie.php
                 'event_city
                 */
                NSMutableDictionary *dictParams = [@{
                                                     @"event_city" : user_City
                                                     } mutableCopy];
                
                [self callMenuWebservice:@"religious.php" dictParams:dictParams];
                
            }else if ([self.labelMenuSelectedName.text isEqualToString:@"Banks & ATMs"]){
                _photo = NO;
                _isEvent = NO;
                typeName = @"Banks & ATMs";
                isFeatured = NO;
                isVenue = NO;
                /*http://socialbud.imvisile.com/api/users/banks.php
                 'event_city
                 */
                NSMutableDictionary *dictParams = [@{
                                                     @"event_city" : user_City
                                                     } mutableCopy];
                
                [self callMenuWebservice:@"banks.php" dictParams:dictParams];
                
            }else if ([self.labelMenuSelectedName.text isEqualToString:@"Movies"]){
                _photo = NO;
                _isEvent = NO;
                typeName = @"Movies";
                isFeatured = NO;
                isVenue = NO;
                /*http://socialbud.imvisile.com/api/users/movie.php
                 'event_city
                 */
                NSMutableDictionary *dictParams = [@{
                                                     @"event_city" : user_City
                                                     } mutableCopy];
                
                [self callMenuWebservice:@"movie.php" dictParams:dictParams];
                
            }else if ([self.labelMenuSelectedName.text isEqualToString:@"Featured Venues"]){
                _photo = NO;
                _isEvent = NO;
                typeName = @"Featured Venues";
                isFeatured = YES;
                isVenue = YES;
                /*http://socialbud.imvisile.com/api/users/venues.php
                 'event_city
                 */
                NSMutableDictionary *dictParams = [@{
                                                     @"event_city" : user_City
                                                     } mutableCopy];
                
                [self callMenuWebservice:@"venues.php" dictParams:dictParams];
                
            }else if ([self.labelMenuSelectedName.text isEqualToString:@"Photo Feed"]){
                
                _photo = YES;
                _isEvent = NO;
                typeName = @"Photo Feed";
                isFeatured = NO;
                isVenue = NO;
//                [tableViewEvents reloadData];
                
                /*http://socialbud.imvisile.com/api/users/localsecreat.php
                 'event_city
                 */
                NSMutableDictionary *dictParams = [@{
                                                     @"event_city" : user_City
                                                     } mutableCopy];
                
                [self callMenuWebservice:@"get_Eventimages.php" dictParams:dictParams];
                
            }else if ([self.labelMenuSelectedName.text isEqualToString:@"Health & Wellness"]){
                if (!isPullRefresh) {
                    [buttonEventType setTitle:@"All Categories" forState:UIControlStateNormal];
                }
                constraintTableViewTop.constant = 62;
                viewDropDownTop.hidden = NO;
                [buttonAllEvents setTitle:@"All Categories" forState:UIControlStateNormal];
                [buttonNightlife setTitle:@"Hospitals" forState:UIControlStateNormal];
                [buttonEducation setTitle:@"Pharmacies" forState:UIControlStateNormal];
                [buttonSports setTitle:@"Gyms" forState:UIControlStateNormal];
                [buttonFestivals setTitle:@"Spas" forState:UIControlStateNormal];

               // constraintViewDropDown.constant = 205;

                _photo = NO;
                _isEvent = NO;
                typeName = @"Health & Wellness";
                isFeatured = NO;
                isVenue = NO;
                /*http://socialbud.imvisile.com/api/users/localsecreat.php
                 'event_city
                 */
                NSMutableDictionary *dictParams = [@{
                                                     @"event_city" : user_City
                                                     } mutableCopy];
                
                [self callMenuWebservice:@"localsecreat.php" dictParams:dictParams];                
            }

        } else {
            [self updateAllEventsName];
            _photo = NO;
            _isEvent = YES;
            typeName = @"Events";
            isFeatured = NO;
            isVenue = NO;
            [buttonEventType setTitle:[USUserInfoModel sharedInstance].user_event_type forState:UIControlStateNormal];
            if (!isPullRefresh) {
                [buttonEventType setTitle:@"All Events" forState:UIControlStateNormal];
            }

            constraintViewDropDown.constant = 0;
            
            self.viewTopTitles.hidden = YES;
            self.viewTopButtons.hidden = NO;

            constraintTableViewTop.constant = 62;
            viewDropDownTop.hidden = NO;
            if (boolThisWeek == YES){
                NSMutableDictionary *dictParams = [@{
                                                     @"event_city" : user_City
                                                     } mutableCopy];
                
                [self callMenuWebservice:@"event_by_week.php" dictParams:dictParams];
            }else{
                [self callAllEvent];
            }
        
            
            //arrayEvents = [USUserInfoModel sharedInstance].arrayEvents;
            //[tableViewEvents reloadData];
        }
    }
    isPullRefresh = NO;
}

#pragma mark - DZNEmptyDataSet DataSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    //NoResultFound
    return [UIImage imageNamed:@""];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Sorry..!!!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [NSString stringWithFormat:@"Sorry no result found for %@", typeName] ;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.0];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

#pragma mark - DZNEmptyDataSet Delegate Implementation

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    NSLog(@"you tap the empty data source");
}

#pragma mark - call API
- (void)callAllEvent{
    
    WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
    
    inputParam.webserviceRelativePath = @"all_event.php";
    
    inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
    
    inputParam.dictPostParameters = [@{
                                       @"event_city" :[USUserInfoModel sharedInstance].user_city,
                                       @"category" :@""
                                       } mutableCopy];
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"All events response==>%@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            HIDE_LOADING();

            
            labelUnderWeek.hidden = YES;
            labelUnderNearMe.hidden = NO;
            [refreshControl endRefreshing];
            
        });
        
        if([[response valueForKeyPath:@"status.code"] isEqual:@"1"]){
            
            NSArray *array = [response valueForKey:@"body"];
            
            if (array.count) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    HIDE_LOADING();
                    labelUnderWeek.hidden = YES;
                    labelUnderNearMe.hidden = NO;
                    [refreshControl endRefreshing];
                    
                    arrayTempEvents = array;
                    arrayEvents = arrayTempEvents;
                    [USUserInfoModel sharedInstance].arrayEvents = arrayTempEvents;
                    
                    if (![buttonEventType.currentTitle isEqualToString:@"All Events"]) {
                        
                        NSString* filter = @"%K CONTAINS[cd] %@";
                        
                        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"category", [NSString stringWithFormat:@"%@",[USUserInfoModel sharedInstance].user_event_type]];
                        
                        arrayEvents = [arrayEvents filteredArrayUsingPredicate:predicate];
                        
                       
                    }
                    
//                    [buttonEventsNearMe setSelected:YES];
//                    [buttonThisWeek setSelected:NO];
                    self->labelUnderWeek.hidden = YES;
                    self->labelUnderNearMe.hidden = NO;
                    [self->tableViewEvents reloadData];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //Table is empty
                     HIDE_LOADING();
                    [UIAlertController alertControllerWithTitle:@"No Events!" message:@"Sorry, We don't have any event right now for this city, please choose another city" buttonTitle:@"OK" viewController:self alertAction:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                });
                
            }
            
        } else if ([[response valueForKeyPath:@"status.code"] isEqual:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                 HIDE_LOADING();
                [UIAlertController showAlertWithTitle:@"No Events Founds" message:@"" onViewController:self];
            });
        }
        
    } error:^(id response, NSError *error) {
         HIDE_LOADING();
        NSLog(@"%@",error.userInfo);
    }];
    
}


- (void)callMenuWebservice:(NSString *)relativePathName dictParams:(NSMutableDictionary *)dictParams{

WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
inputParam.webserviceRelativePath = relativePathName;
inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
inputParam.dictPostParameters = dictParams;
    
    [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
        
        NSLog(@"Login Response==>%@",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            HIDE_LOADING();
            [refreshControl endRefreshing];
            
        });
        
        if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"])
        {
            NSArray *arrResponse;
            
            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"%@",[response valueForKey:@"body"]]] == false)
            {
                arrResponse = [response valueForKey:@"body"];
            }
            else
            {
                arrResponse = nil;
            }
            
            
            
            //            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserInfo"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                _photo = NO;
                
                if ([arrResponse count] >0 )
                {
                    arrayTempEvents = arrResponse;
                    arrayEvents = arrayTempEvents;
                    
                    if (![[USUserInfoModel sharedInstance].user_event_type isEqualToString:@"All Events"] && [relativePathName isEqualToString:@"event_by_week.php"]) {
                        
                        NSString* filter = @"%K CONTAINS[cd] %@";
                        
                        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"category", [NSString stringWithFormat:@"%@",[USUserInfoModel sharedInstance].user_event_type]];
                        
                        arrayEvents = [arrayEvents filteredArrayUsingPredicate:predicate];
                        
//                        NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"category == '%@'",[USUserInfoModel sharedInstance].user_event_type]];
//                        arrayEvents = [arrayTempEvents filteredArrayUsingPredicate:pred];
                    }
                    
//                    if ([self.labelMenuSelectedName.text isEqualToString:@"Health & Wellness"]) {
//                        if (![[USUserInfoModel sharedInstance].user_event_type isEqualToString:@"All Categories"]) {
//                            NSString* filter = @"%K CONTAINS[cd] %@";
//
//                            NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"subcategory", [NSString stringWithFormat:@"%@",[USUserInfoModel sharedInstance].user_event_type]];
//
//                            arrayEvents = [arrayEvents filteredArrayUsingPredicate:predicate];
//                        }
//                    }
                   

                    
                }else{
                    //response is empty make array nil
                    
                    arrayTempEvents = nil;
                    arrayEvents = nil;
//        [UIAlertController showAlertWithTitle:appNAME message:@"No result found..!!" onViewController:self];
                }
                
                [tableViewEvents reloadData];
                
//                [self performSegueWithIdentifier:@"CBCityListViewController" sender:nil];
            });
            
        } else if ([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController showAlertWithTitle:appNAME message:[response valueForKeyPath:@"status.message"] onViewController:self];
            });
        }
        
    } error:^(id response, NSError *error) {
        NSLog(@"%@",error.userInfo);
//        [UIAlertController showAlertWithTitle:appNAME message:@"Something went wrong, Please try again later.!!" onViewController:self];
    }];

}


#pragma mark - Bution Actions
- (IBAction)buttonCreateEventClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:@"CBSearchViewController" sender:nil];
}
- (IBAction)buttonEventTypeClicked:(UIButton *)sender {
    
    if (sender.selected == YES) {
        [sender setSelected:NO];

        constraintViewDropDown.constant = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        [sender setSelected:YES];
        if ([self.labelMenuSelectedName.text isEqualToString:@"Health & Wellness"]) {
            constraintViewDropDown.constant = 205;
        } else if ([self.labelMenuSelectedName.text isEqualToString:@"Religious"]) {
            constraintViewDropDown.constant = 122;
        } else {
            constraintViewDropDown.constant = 287;
        }
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)buttonEventSelectClicked:(UIButton *)sender {
    
    if (buttonEventsNearMe.selected == YES) {
        
        arrayEvents = [USUserInfoModel sharedInstance].arrayEvents;
        
    } else {
        
        arrayEvents = arrayTempEvents;
    }
    
    constraintViewDropDown.constant = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [buttonEventType setSelected:NO];


    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"] mutableCopy];
    [dict setObject:sender.titleLabel.text forKey:@"user_event_type"];
    [USUserInfoModel sharedInstance].user_event_type = sender.titleLabel.text;
    
    NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
    
    for (NSString * key in [dict allKeys])
    {
        if (![[dict objectForKey:key] isKindOfClass:[NSNull class]])
            [prunedDictionary setObject:[dict objectForKey:key] forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:prunedDictionary forKey:@"UserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [buttonEventType setTitle:[USUserInfoModel sharedInstance].user_event_type forState:UIControlStateNormal];
    
    if (![sender.titleLabel.text isEqualToString:@"All Events"]) {
        
        if (![sender.titleLabel.text isEqualToString:@"All Categories"]) {
            NSLog(@"%@",[NSString stringWithFormat:@"%@",sender.titleLabel.text]);
            
            NSLog(@"%@",[NSString stringWithFormat:@"category == '%@'",sender.titleLabel.text]);
            
            
            NSString *SearchTitel = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
            
            //NSString* filter = @"%K CONTAINS %@";
            NSString* filter = @"%K CONTAINS[cd] %@";
            
            NSPredicate* predicate;
            if ([self.labelMenuSelectedName.text isEqualToString:@"Health & Wellness"]) {
                predicate = [NSPredicate predicateWithFormat:filter, @"subcategory", SearchTitel];
            } else {
                predicate = [NSPredicate predicateWithFormat:filter, @"category", SearchTitel];
            }
            
            // NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"category", SearchTitel];
            
            arrayEvents = [arrayEvents filteredArrayUsingPredicate:predicate];
        }
    }
     [tableViewEvents reloadData];
}

- (IBAction)buttonMenuClicked:(UIButton *)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

- (IBAction)buttonEventsNearMeClicked:(UIButton *)sender {
    boolThisWeek = NO;
    
    [buttonEventsNearMe setSelected:YES];
    [buttonThisWeek setSelected:NO];
    
    labelUnderWeek.hidden = YES;
    labelUnderNearMe.hidden = NO;
   
    arrayEvents = [USUserInfoModel sharedInstance].arrayEvents;
    
    if (![[USUserInfoModel sharedInstance].user_event_type isEqualToString:@"All Events"]) {
        
        
        NSString* filter = @"%K CONTAINS[cd] %@";
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"category", [NSString stringWithFormat:@"%@",[USUserInfoModel sharedInstance].user_event_type]];
        
        arrayEvents = [arrayEvents filteredArrayUsingPredicate:predicate];
        
//        NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"category == '%@'",[USUserInfoModel sharedInstance].user_event_type]];
//        arrayEvents = [arrayEvents filteredArrayUsingPredicate:pred];
    }
    
    [tableViewEvents reloadData];

}

- (IBAction)buttonThisWeekClicked:(UIButton *)sender {
    
    boolThisWeek = YES;
    
    [buttonEventsNearMe setSelected:NO];
    [buttonThisWeek setSelected:YES];
    labelUnderWeek.hidden = NO;
    labelUnderNearMe.hidden = YES;
    
        NSMutableDictionary *dictParams = [@{
                                             @"event_city" : user_City
                                             } mutableCopy];
        
        [self callMenuWebservice:@"event_by_week.php" dictParams:dictParams];
    
}

#pragma mark - TableView Delegate Methods...
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayEvents.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_photo){
        static NSString *simpleTableIdentifier = @"CBPhotoFeedTableViewCell";
        CBPhotoFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[CBPhotoFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }


        [cell.imageGallery.layer setBorderColor: [[UIColor colorWithRed:0.09 green:0.31 blue:0.50 alpha:1.0] CGColor]];
        [cell.imageGallery.layer setBorderWidth: 3.5];

        NSString *imageName = [NSString stringWithFormat:@"%@",[arrayEvents[indexPath.row][@"gallery"][0] objectForKey:@"event_image"]];
        imageName = [imageName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [cell.imageGallery sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"logo_small"] options:SDWebImageRefreshCached];
      
//        [cell.imageGallery setImage:[UIImage imageNamed:[dictPhoto[@"gallery"][0] objectForKey:@"event_image"]]];
        
        cell.labelGalleryName.text = arrayEvents[indexPath.row][@"event_name"];
        
        cell.labelCount.text = [NSString stringWithFormat:@"%lu",[arrayEvents[indexPath.row][@"gallery"] count]];
        
        return cell;
        
    }
    else
    {
    
        static NSString *simpleTableIdentifier = @"CBEventsTableViewCell";
        
        CBEventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[CBEventsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        [cell.viewCenterContainer setHidden:YES];
        [cell.viewBottomContainer setHidden:YES];
        
        NSDictionary *dict = arrayEvents[indexPath.row];
        
        if (_isEvent == TRUE){
            [cell.imageFeaturedStar setHidden:YES];
            [cell.viewCenterContainer setHidden:YES];
            [cell.viewBottomContainer setHidden:NO];
            
            cell.labelCenterName.text = @"";
            cell.labelCenterAddress.text = @"";
            
            cell.labelEventName.text = dict[@"event_name"];
            cell.labelEventAddress.text = dict[@"event_venue"];
            cell.lavelEventCity.text = dict[@"event_city"];
            
            
            NSString *Price = [NSString stringWithFormat:@"%@", dict[@"ticket_price"]];
            NSString *PriceR = [NSString stringWithFormat:@"%@", dict[@"ticket_price_regular"]];
            NSString *PriceV = [NSString stringWithFormat:@"%@", dict[@"ticket_price_vip"]];
            NSString *PriceVV = [NSString stringWithFormat:@"%@", dict[@"ticket_price_vvip"]];
            
//            "ticket_price_regular" = 0;
//            "ticket_price_vip" = 0;
//            "ticket_price_vvip" = 500;
            
            if ([Price isEqualToString:@"0"] && [PriceR isEqualToString:@"0"] && [PriceV isEqualToString:@"0"] && [PriceVV isEqualToString:@"0"])
            {
                 cell.labelEventPrice.text = @"Free";
                
            }else if ([PriceR isEqualToString:@"0"] && [PriceV isEqualToString:@"0"]) {
                
                if ([PriceVV isEqualToString:@"0"])
                {
                    cell.labelEventPrice.text = @"Free";
                 
                }else
                {
                    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"N %@", dict[@"ticket_price_vvip"]]])
                    {
                        cell.labelEventPrice.text = @"Free";
                    }
                    else
                    {
                        cell.labelEventPrice.text = [NSString stringWithFormat:@"N %@", dict[@"ticket_price_vvip"]];
                    }
                }
                
            } else{
                
                NSLog(@"%@",[NSString stringWithFormat:@"N %@", dict[@"ticket_price_regular"]]);
                
                if ([Price isEqualToString:@"0"]) {
                    
                    if ([PriceV isEqualToString:@"0"]) {
                        
                        if ([PriceVV isEqualToString:@"0"]) {
                            
                            cell.labelEventPrice.text = @"Free";
                            
                        }else{
                            if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"N %@", dict[@"ticket_price_vvip"]]])
                            {
                                cell.labelEventPrice.text = @"Free";
                            }
                            else
                            {
                                cell.labelEventPrice.text = [NSString stringWithFormat:@"N %@", dict[@"ticket_price_vvip"]];
                            }
                        }
                        
                    }else{
                        if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"N %@", dict[@"PriceV"]]])
                        {
                            cell.labelEventPrice.text = @"N";
                        }
                        else
                        {
                            cell.labelEventPrice.text = [NSString stringWithFormat:@"N %@", dict[@"PriceV"]];
                        }
                    }
 
                }else{
                    if ([STMethod stringIsEmptyOrNot:[NSString stringWithFormat:@"N %@", dict[@"ticket_price_regular"]]])
                    {
                        cell.labelEventPrice.text = @"N";
                    }
                    else
                    {
                        cell.labelEventPrice.text = [NSString stringWithFormat:@"N %@", dict[@"ticket_price_regular"]];
                    }
                }
                
            }
            
            
                        
        }else{
            if(isFeatured == YES && [dict[@"verificationcode"] isEqualToString:@"1"]){
                [cell.imageFeaturedStar setHidden:NO];
            }else{
                [cell.imageFeaturedStar setHidden:YES];
            }
            
            [cell.viewCenterContainer setHidden:NO];
            [cell.viewBottomContainer setHidden:YES];
            
            cell.labelCenterName.text = dict[@"event_name"];
            cell.labelCenterAddress.text = dict[@"event_address"];
            
//            if(isVenue){
//                cell.labelCenterAddress.text = dict[@"event_address"];
//            }else{
//                cell.labelCenterAddress.text = dict[@"event_venue"];
//            }
            
            cell.labelEventName.text = @"";
            cell.labelEventAddress.text = @"";
            cell.lavelEventCity.text = @"";
            cell.labelEventPrice.text = @"";
        }
        
        cell.imageViewEvent.alpha = 0.0f;
        
//        [cell.imageViewEvent sd_setImageWithURL:[NSURL URLWithString:dict[@"event_pic"]]
//                             placeholderImage:[UIImage imageNamed:@"logo_small"] options:SDWebImageRefreshCached];
//
        
        NSArray *arrEventPics = [dict[@"event_pic"] componentsSeparatedByString:@","];
        
        
        if ([arrEventPics[0] isEqualToString:@""]){
            [cell.imageViewEvent setBackgroundColor:[UIColor colorWithRed:0.09 green:0.31 blue:0.50 alpha:1.0]];
            [cell.imageViewEvent setImage:[UIImage imageNamed:@"logo_small"]];
        }else{
            
            NSString *imageName = [NSString stringWithFormat:@"%@",arrEventPics[0]];
            imageName = [imageName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:imageName]];
            
            [cell.imageViewEvent setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"logo_small"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                cell.imageViewEvent.image = image;
                
                [UIView animateWithDuration:0.5 animations:^{
                    cell.imageViewEvent.alpha = 1.0f;
                }];
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                cell.imageViewEvent.image = [UIImage imageNamed:@"logo_small"];
            }];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_photo)
    {
        dictEventInfo = arrayEvents[indexPath.row];
        
        [self performSegueWithIdentifier:@"CBHomeDetailsViewController" sender:nil];
        //labelMenuSelectedName
    }
    else
    {
        //CBPhotoGalleryViewController
        [self performSegueWithIdentifier:@"photoGalleryCollectionView" sender:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_photo){
        return 95;
    }else{
        return 160;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CBHomeDetailsViewController"])
    {
        CBHomeDetailsViewController *dVC = segue.destinationViewController;
        dVC.dictEventInfo = dictEventInfo;
        dVC.cityName = self.labelCityName.text;
        dVC.eventType = self.labelMenuSelectedName.text;
        dVC.isVenue = isVenue;
        if (_isEvent == NO){
            dVC.showUberView = YES;
        }
        
    }else if ([segue.identifier isEqualToString:@"photoGalleryCollectionView"]){
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        CBGalleryViewController *galleryVC = segue.destinationViewController;
        galleryVC.dictgallery = arrayEvents[indexPath.row];
    }
}

@end
