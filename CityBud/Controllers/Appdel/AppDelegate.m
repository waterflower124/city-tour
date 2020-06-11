//
//  AppDelegate.m
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
//#import <TwitterKit/TwitterKit.h>
#import <Twitter/Twitter.h>
#import <TwitterKit/TWTRKit.h>
#import "LocationTracker.h"
#import <UberRides/UberRides-Swift.h>
#import <UberCore/UberCore-Swift.h>
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@import GoogleMaps;
@import GooglePlaces;
#define USERDEFAULT [NSUserDefaults standardUserDefaults]
#define IS_IOS10 [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0f
#define IS_IOS9 [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f
#define IS_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f

@interface AppDelegate ()
{
    NSString* DeviceTok;
}

@end

@implementation AppDelegate
@synthesize signUP, attendingPeople,ValueStr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //com.citybud.app
    attendingPeople = @"no";
    
    [self.window setBackgroundColor:[UIColor whiteColor]];
//    [self.window.superview setBackgroundColor:[UIColor whiteColor]];
//    self.window.screen.focusedView.backgroundColor = [UIColor whiteColor];

    
     //[[Twitter sharedInstance] startWithConsumerKey:@"pnTd3gA75JSqZM7PYvufD29Lh" consumerSecret:@"INLQ2AlDwa99T8lCFtLHxUhV07h9ceOFLOT1ZuGnZXZMd9peSB"];
    
    
    
    //Twitter
    [[Twitter sharedInstance] startWithConsumerKey:@"pnTd3gA75JSqZM7PYvufD29Lh" consumerSecret:@"INLQ2AlDwa99T8lCFtLHxUhV07h9ceOFLOT1ZuGnZXZMd9peSB"];
    
    
  //  Live key
    [Paystack setDefaultPublicKey:@"pk_live_b0a4df6177113e6584a62c989f5a6f60ca26a9aa"];

    
    // test key
   //[Paystack setDefaultPublicKey:@"pk_test_ed4394f6311053b6d8277dd3e6fb8837738e113e"];
    

    //https://citybudapple.herokuapp.com
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];//
    // Add any custom logic here.
    
    //[Fabric with:@[[Twitter class]]];
    
    
    //Client's APIKey
   // [GMSServices provideAPIKey:@"AIzaSyCLIJa9LzmKjBn8JmXq-sLoLFBeglbJUFA"];
    
    [GMSServices provideAPIKey:@"AIzaSyBVqlhklDey1KXX1cvCKgd7xjy3ZTPbYPg"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyBVqlhklDey1KXX1cvCKgd7xjy3ZTPbYPg"];
    
     _services = [GMSServices sharedServices];
    
    [[LocationTracker sharedInstance] startLocationTracking];

    
    // change navigation bar textcolor
    
    //#1D4F83 = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1]
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.11 green:0.31 blue:0.51 alpha:1.0]]; // this will change the back button tint
    
   /* [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:65.0/255.0f green:65.0/255.0f blue:65.0/255.0f alpha:.70]}];*/
    
// tab bar clolor and unselected icon color
//    [UIColor colorWithRed:29.0/255.0f green:79.0/255.0f blue:131.0/255.0f alpha:1]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.11 green:0.27 blue:0.47 alpha:1.0]];
   
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];
    
    
    //Uber Integration
    // China based apps should specify the region
    [[UBSDKConfiguration shared] setIsSandbox:YES];
    [[UBSDKConfiguration shared] setUseFallback:YES];
//    [UBSDKConfiguration setRegion:RegionDefault];
    // If true, all requests will hit the sandbox, useful for testing
//    [UBSDKConfiguration setSandboxEnabled:YES];
    // If true, Native login will try and fallback to using Authorization Code Grant login (for privileged scopes). Otherwise will redirect to App store
//    [UBSDKConfiguration setFallbackEnabled:NO];
    // Complete other setup
    
    if(IS_IOS10)
    {
        [self registerForPushNotitificationService_iOS10AndLater];
        
    }
    else
    {
        [self registerForPushNotitificationService_TilliOS9];
    }
    
    
    return YES;
    
    
}
#pragma mark - Register PushNotification Till iOS 9
-(void)registerForPushNotitificationService_TilliOS9
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
}
#pragma mark - pushNotification Delegate

#pragma mark - Notification Delegate for iOS 10
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
}
#pragma mark - Notification Delegate for iOS 9 and later
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)(void))completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
        
    }
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* strdeviceToken = [[NSString alloc]init];
    
    strdeviceToken=[self stringWithDeviceToken:deviceToken];
    DeviceTok=strdeviceToken;
    
    [USERDEFAULT setObject:strdeviceToken forKey:@"deviceToken"];
    
    [USERDEFAULT synchronize];
    
    NSLog(@"My token is: %@",strdeviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    
    [USERDEFAULT removeObjectForKey:@"deviceToken"];
    [USERDEFAULT synchronize];
    
#if TARGET_IPHONE_SIMULATOR
    
    //[USERDEFAULT setObject:@"" forKey:kToken];
    //[USERDEFAULT synchronize];
    
#endif
}

#pragma mark - Notification for iOS 10 and Later

-(void)registerForPushNotitificationService_iOS10AndLater
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if( !error ){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
}

-(void)handleRemoteNitification:(UIApplication *)application userInfo:(NSDictionary *)userInfo
{
    
}

- (NSString*)stringWithDeviceToken:(NSData*)deviceToken
{
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++)
    {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    return [token copy] ;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [self.window endEditing:YES];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Facebook Login Integration
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation];
//}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL uberHandled = [[UBSDKAppDelegate shared] application:application
                                                         open:url
                                            sourceApplication:sourceApplication
                                                   annotation:annotation];
    
    BOOL facebookHandled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    
    // Add any custom logic here.
    return uberHandled || facebookHandled;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL TwitterHandled = [[Twitter sharedInstance]application:app openURL:url options:options];
    
    BOOL facebookHandled = [[FBSDKApplicationDelegate sharedInstance]application:app openURL:url options:options];
    
    return TwitterHandled || facebookHandled ;
}

/*
// iOS 9+
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    BOOL handledURL = [[UBSDKRidesAppDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    if (!handledURL) {
        // Other URL logic
    }
    
    return true;
}
*/


@end
