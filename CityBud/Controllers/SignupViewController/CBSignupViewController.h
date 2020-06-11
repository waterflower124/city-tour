//
//  CBSignupViewController.h
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSignupViewController : UIViewController<UITextFieldDelegate>{
    
    __weak IBOutlet kzTextField *tfSignupFirstName;
    __weak IBOutlet kzTextField *tfSignupLastName;
    __weak IBOutlet kzTextField *tfSignupEmailAddress;
    __weak IBOutlet kzTextField *tfSignupPassword;
    __weak IBOutlet kzTextField *tfSignupConfirmPassword;

}

- (IBAction)actionCreateAccount:(UIButton *)sender;
- (IBAction)actionAlreadyMember:(UIButton *)sender;
- (IBAction)actionFbSignup:(UIButton *)sender;
- (IBAction)actionTwSignup:(UIButton *)sender;


@end
