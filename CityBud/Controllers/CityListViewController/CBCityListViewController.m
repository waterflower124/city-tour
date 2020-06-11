//
//  CBCityListViewController.m
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBCityListViewController.h"
#import "CBEventTypeViewController.h"
#import "CBMenuViewController.h"
#import "CBHomeViewController.h"

@interface CBCityListViewController (){

    NSString *choosenCity;
}

@end

@implementation CBCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionChooseCity:(UIButton *)sender {
    
    if (sender.tag == 101) {
        choosenCity = labelCalabar.text;
    } else if (sender.tag == 102) {
        choosenCity = labelPort.text;
    } else if (sender.tag == 103) {
        choosenCity = labelAbuja.text;
    } else if (sender.tag == 104) {
        choosenCity = labelOwerri.text;
    } else if (sender.tag == 105) {
        choosenCity = labelLagos.text;
    }
    
     NSMutableDictionary *dict12 = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"] mutableCopy];
    
    NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
    
    for (NSString * key in [dict12 allKeys])
    {
        if (![[dict12 objectForKey:key] isKindOfClass:[NSNull class]])
            [prunedDictionary setObject:[dict12 objectForKey:key] forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:prunedDictionary forKey:@"UserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"] mutableCopy];
    
    [dict removeObjectForKey:@"user_city"];//remove old city
    [dict setObject:choosenCity forKey:@"user_city"];//updating the user city
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"]; // deleting the old city value dict
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserInfo"]; // adding new city value dict
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [USUserInfoModel sharedInstance].user_city = choosenCity;
    
    NSString *currentEventType = [dict objectForKey:@"user_event_type"];
    
    if (currentEventType.length != 0){
        //move direct to home
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        CBMenuViewController *leftMenu = (CBMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CBMenuViewController"];
        
        MFSideMenuContainerViewController *slideVC = (MFSideMenuContainerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MFSideMenuContainerViewController"];
        
        UITabBarController *tabBarVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"CBTabBarController"];
        
        slideVC = [MFSideMenuContainerViewController
                   containerWithCenterViewController:tabBarVC
                   leftMenuViewController:leftMenu
                   rightMenuViewController:nil];
        slideVC.menuWidth = self.view.frame.size.width-50;
        [self presentViewController:slideVC animated:NO completion:nil];
    }else{
        // move to Choose Event screen
        [self performSegueWithIdentifier:@"CBEventTypeViewController" sender:sender];
    }
    
//    if (dict) {
//
//
//        [self performSegueWithIdentifier:@"CBEventTypeViewController" sender:sender];
//    } else {
//        
////        [UITabBarController setSelectedViewController:CBHomeViewController];
//        
////        [self performSegueWithIdentifier:@"CBEventTypeViewController" sender:sender];
//    }
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CBEventTypeViewController"]){
        CBEventTypeViewController *eventTypeVC = segue.destinationViewController;
        eventTypeVC.cityName = choosenCity;
    } 
    
    
}


@end
