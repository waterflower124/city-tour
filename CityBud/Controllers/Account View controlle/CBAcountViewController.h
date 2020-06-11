//
//  CBAcountViewController.h
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CBAcountViewController : UIViewController <MFMailComposeViewControllerDelegate>{

    __weak IBOutlet UIButton *buttonChangePassword;
    __weak IBOutlet UIButton *buttonChangeEmail;
    __weak IBOutlet UIButton *buttonYourEvents;
    __weak IBOutlet UIButton *buttonTnC;
    __weak IBOutlet UIButton *buttonPrivacy;
    
    __weak IBOutlet UIButton *buttonRequestRide;
}

@property (readwrite, nonatomic) BOOL isPrivacy;

- (IBAction)actionChangePassword:(UIButton *)sender;
- (IBAction)actionChangeEmail:(UIButton *)sender;
- (IBAction)actionYourEvents:(UIButton *)sender;
- (IBAction)actionLogout:(UIButton *)sender;
- (IBAction)actionRequestRide:(UIButton *)sender;
- (IBAction)actionTnC:(UIButton *)sender;
- (IBAction)actionPrivacy:(UIButton *)sender;
- (IBAction)actionContactUS:(UIButton *)sender;


@end
