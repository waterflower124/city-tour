//
//  CBSearchViewController.h
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSearchViewController : UIViewController<UITextFieldDelegate>{

    __weak IBOutlet NSLayoutConstraint *constraintsViewDD;
//    __weak IBOutlet NSLayoutConstraint *constraintViewDropDown;
    
    __weak IBOutlet UIButton *buttonCategory;
    __weak IBOutlet kzTextField *tfSearchQuery;
    
    IBOutlet kzTextField *DateShow;
    
    IBOutlet UIButton * CalenderButton;
    
    IBOutlet NSLayoutConstraint *category_height;
    
    IBOutlet NSLayoutConstraint *total_height;
    
    IBOutlet UILabel *  selectdatelbl;
    
    IBOutlet UIImageView * calenderIcon;
}
- (IBAction)CalenderButtonClick:(UIButton *)sender;

- (IBAction)actionSearch:(UIButton *)sender;

@property  BOOL SearchByDate;

@end
