//
//  CBLoginViewController.h
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CBLoginViewController : UIViewController<UITextFieldDelegate,MFMailComposeViewControllerDelegate>{
    __weak IBOutlet kzTextField *textFielsLoginEmail;    
    __weak IBOutlet kzTextField *textFieldLoginPassword;
    __weak IBOutlet kzTextField *textFieldFoegetEmail;
}





- (IBAction)buttonRegisterClicked:(UIButton *)sender;
- (IBAction)actionForgetPassword:(UIButton *)sender;
- (IBAction)actionForgetSave:(UIButton *)sender;
- (IBAction)actionHelpCenter:(UIButton *)sender;
- (IBAction)actionFBLogin:(UIButton *)sender;
- (IBAction)actionTwLogin:(UIButton *)sender;

@end
