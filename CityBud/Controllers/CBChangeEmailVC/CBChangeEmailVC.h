//
//  CBChangeEmailVC.h
//  CityBud
//
//  Created by Mohit Garg on 01/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBChangeEmailVC : UIViewController<UITextFieldDelegate>{

    __weak IBOutlet kzTextField *tfOldEmail;
    __weak IBOutlet kzTextField *tfNewEmail;
    __weak IBOutlet kzTextField *tfConfirmEmail;
    
}
- (IBAction)actionChangeEmail:(UIButton *)sender;
- (IBAction)actionBackButton:(UIButton *)sender;

@end
