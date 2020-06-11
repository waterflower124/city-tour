//
//  CBChangePasswordVC.h
//  CityBud
//
//  Created by Mohit Garg on 01/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBChangePasswordVC : UIViewController<UITextFieldDelegate>{

    __weak IBOutlet kzTextField *tfOldPassword;
    __weak IBOutlet kzTextField *tfNewPassword;
    __weak IBOutlet kzTextField *tfConfirmPassword;
    

}

- (IBAction)actionBackButton:(UIButton *)sender;
- (IBAction)actionChangePassword:(UIButton *)sender;


@end
