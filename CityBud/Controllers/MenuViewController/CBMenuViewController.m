//
//  CBMenuViewController.m
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBMenuViewController.h"
#import "CBMenuTableViewCell.h"
#import "CBHomeViewController.h"
#import "CBEventTypeViewController.h"
#import "CBCreateEventViewController.h"

@interface CBMenuViewController ()
{
    NSArray *arrayMenuItems;
    NSArray *arrayMenuImages;
    
}
@end

@implementation CBMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayMenuItems = [NSArray arrayWithObjects:@"Change Location",@"Events", @"Restaurants",@"Hotspots", @"Banks & ATMs", @"Health & Wellness", @"Movies",@"Religious", @"Featured Venues",@"Photo Feed", nil];
    
    arrayMenuImages = [NSArray arrayWithObjects:@"menu_change_location",@"menu_events", @"menu_dinning",@"menu_create_event", @"menu_banks", @"menu_local", @"menu_movies",@"menu_change_location", @"menu_featured", @"menu_photo", nil];

    
    [tableViewMenu reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate Methods...
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayMenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CBMenuTableViewCell";
    CBMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[CBMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.labelItemName.text = arrayMenuItems[indexPath.row];
    cell.imageViewItem.image = [UIImage imageNamed:arrayMenuImages[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    //CBMenuViewController *leftMenu = (CBMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"CBMenuViewController"];
    
    //MFSideMenuContainerViewController *slideVC = (MFSideMenuContainerViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MFSideMenuContainerViewController"];
    
    UITabBarController *tabBarController = self.menuContainerViewController.centerViewController;
    
    NSArray *array = tabBarController.viewControllers;
    
    if ((indexPath.row >= 1 && indexPath.row <= 9) || indexPath.row == 8 || indexPath.row == 9  ||indexPath.row == 7)
    {

        UINavigationController *hNVC = array[0];
        
        for (UIViewController *controller in hNVC.viewControllers) {
            if ([controller isKindOfClass:[CBHomeViewController class]]) {
                CBHomeViewController *hVC = (CBHomeViewController *)controller;
                hVC.labelMenuSelectedName.text = [NSString stringWithFormat:@"%@", arrayMenuItems[indexPath.row]];
                
                if (indexPath.row != 0) {
                    hVC.viewTopTitles.hidden = NO;
                    hVC.viewTopButtons.hidden = YES;
                } else {
                    hVC.viewTopTitles.hidden = YES;
                    hVC.viewTopButtons.hidden = NO;
                }
                
                [tabBarController setSelectedViewController:hNVC];
            }
        }
       
    } else if (indexPath.row == 7) {
        // Create Event
        UINavigationController *hNVC = array[0];
        
        UIViewController *homeVC = [hNVC.viewControllers objectAtIndex:0];
 
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CBCreateEventViewController *createEventVC = [storyboard instantiateViewControllerWithIdentifier:@"CBCreateEventViewController"];

        [hNVC setViewControllers:[NSArray arrayWithObjects:homeVC, createEventVC, nil] animated:YES];
        [tabBarController setSelectedViewController:hNVC];


    } else if (indexPath.row == 0) {
        
//        UINavigationController *hNVC = array[2];
//        [tabBarController setSelectedViewController:hNVC];
        
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:^{
//
//            
//            CBLoginViewController *CBLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"CBLoginViewController"];
//            [self.navigationController popToViewController:CBLogin animated:YES];
//        }];
         [self dismissViewControllerAnimated:NO completion:^{}];

    }
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

}


@end
