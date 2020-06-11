//
//  CBSplashViewController.m
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBSplashViewController.h"
#import "CBMenuViewController.h"
#import "CBCityListViewController.h"

@interface CBSplashViewController ()

@end

@implementation CBSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"];
    [USUserInfoModel sharedInstance].navVC = self.navigationController;

    if (dict) {
        [USUserInfoModel sharedInstance].user_id = dict[@"id"];
        [USUserInfoModel sharedInstance].firstname = dict[@"firstname"];
        [USUserInfoModel sharedInstance].surname = dict[@"surname"];
        [USUserInfoModel sharedInstance].profile_pic = dict[@"profile_pic"];
        [USUserInfoModel sharedInstance].email = dict[@"email"];
        [USUserInfoModel sharedInstance].user_phone_number = dict[@"mobilenumber"];
        [USUserInfoModel sharedInstance].user_event_type = dict[@"user_event_type"];
        [USUserInfoModel sharedInstance].user_city = dict[@"user_city"];
        
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            SHOW_NETWORK_ERROR_ALERT();
            return;
        } else {
            
            if ([dict[@"user_city"] length] == 0) {
                
                //goto city
                [self performSegueWithIdentifier:@"CBCityListViewController" sender:nil];
                
            } else {
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                
                CBMenuViewController *leftMenu = (CBMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CBMenuViewController"];
                
                MFSideMenuContainerViewController *slideVC = (MFSideMenuContainerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MFSideMenuContainerViewController"];
                
                UITabBarController *tabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"CBTabBarController"];
                
                slideVC = [MFSideMenuContainerViewController
                           containerWithCenterViewController:tabBarVC
                           leftMenuViewController:leftMenu
                           rightMenuViewController:nil];
                slideVC.menuWidth = self.view.frame.size.width-50;
                
                [self presentViewController:slideVC animated:NO completion:^{
                    CBCityListViewController *cVC = (CBCityListViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CBCityListViewController"];
                    
                    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
                    [array addObject:cVC];
                    self.navigationController.viewControllers = array;
                    
                    [USUserInfoModel sharedInstance].navVC = self.navigationController;
                    
                }];

                /*
                WebserviceInputParameter *inputParam = [[WebserviceInputParameter alloc] init];
                inputParam.webserviceRelativePath = @"all_event.php";
                inputParam.serviceMethodType = WEBSERVICE_METHOD_TYPE_POST;
                inputParam.dictPostParameters = [@{
                                                   @"event_city" : [USUserInfoModel sharedInstance].user_city,
                                                   } mutableCopy];
                
                [WDWebserviceHelper callWebserviceWithInputParameter:inputParam success:^(id response, NSError *error) {
                    
                    NSLog(@"All Event for choosen City for Home response==>%@",response);
                    
                    if([[response[@"status"] valueForKeyPath:@"code"] isEqual:@"1"]){
                        HIDE_LOADING();
                        
                        NSArray *array = [response valueForKey:@"body"];
                        
                        if (array.count) {
                            [USUserInfoModel sharedInstance].arrayEvents = array;
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                
                                CBMenuViewController *leftMenu = (CBMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CBMenuViewController"];
                                
                                MFSideMenuContainerViewController *slideVC = (MFSideMenuContainerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MFSideMenuContainerViewController"];
                                
                                UITabBarController *tabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"CBTabBarController"];
                                
                                slideVC = [MFSideMenuContainerViewController
                                           containerWithCenterViewController:tabBarVC
                                           leftMenuViewController:leftMenu
                                           rightMenuViewController:nil];
                                slideVC.menuWidth = self.view.frame.size.width-50;
                                
                                [self presentViewController:slideVC animated:NO completion:^{
                                    CBCityListViewController *cVC = (CBCityListViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CBCityListViewController"];
                                    
                                    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
                                    [array addObject:cVC];
                                    self.navigationController.viewControllers = array;
                                    
                                    [USUserInfoModel sharedInstance].navVC = self.navigationController;
                                
                                }];
                                
                                
                                
                            });
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [UIAlertController alertControllerWithTitle:@"No Events!" message:@"Sorry, We don't have any event right now for this city, please choose another city" buttonTitle:@"OK" viewController:self alertAction:^(UIAlertAction *action) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
                            });
                            
                        }
                        
                    } else if ([[response valueForKeyPath:@"status.code"] isEqual:@"0"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIAlertController showAlertWithTitle:@"No Events Founds" message:@"" onViewController:self];
                        });
                    }
                    
                } error:^(id response, NSError *error) {
                    NSLog(@"%@",error.userInfo);
                }];
                
                */
            }
            
        }
/*
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        CBMenuViewController *leftMenu = (CBMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CBMenuViewController"];
        
        MFSideMenuContainerViewController *slideVC = (MFSideMenuContainerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MFSideMenuContainerViewController"];
        
        UITabBarController *tabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"CBTabBarController"];
        
        slideVC = [MFSideMenuContainerViewController
                   containerWithCenterViewController:tabBarVC
                   leftMenuViewController:leftMenu
                   rightMenuViewController:nil];
        slideVC.menuWidth = self.view.frame.size.width-50;
        [self presentViewController:slideVC animated:NO completion:nil];*/

    } else {
        // Not Login
        [self performSegueWithIdentifier:@"CBLoginViewController" sender:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
