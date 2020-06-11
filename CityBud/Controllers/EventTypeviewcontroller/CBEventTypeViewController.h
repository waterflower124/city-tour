//
//  CBEventTypeViewController.h
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBEventTypeViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>{

    __weak IBOutlet UIButton *buttonNightLife;
    __weak IBOutlet UIButton *buttonEducation;
    __weak IBOutlet UIButton *buttonSports;
    __weak IBOutlet UIButton *buttonFestivals;
    __weak IBOutlet UIButton *buttonReligious;
    
    __weak IBOutlet kzTextField *textFieldPhoneNumber;
    
    __weak IBOutlet UIView *viewDropDownTop;
    __weak IBOutlet UIView *viewDropDownBottom;
    __weak IBOutlet UIView *viewSubmit;
    
    __weak IBOutlet NSLayoutConstraint *constraintDDHeight;
    
    __weak IBOutlet UIButton *buttonChooseEvent;
    
    __weak IBOutlet UIView *viewDropDown;
    
    __weak IBOutlet UILabel * phonenumberlabel;

}

- (IBAction)actionChooseEvent:(id)sender;
    
@property (nonatomic, weak) NSString *cityName;


@end
