//
//  CBTermsAndConditionsViewController.h
//  CityBud
//
//  Created by Mohit Garg on 22/03/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBTermsAndConditionsViewController : UIViewController{

    
    __weak IBOutlet UILabel *labelEventName;
    __weak IBOutlet UILabel *labelContent;
    
    
}

- (IBAction)actionBackButton:(UIButton *)sender;



@property (readwrite, nonatomic) BOOL isPrivacy;

@property (weak, nonatomic) IBOutlet UIWebView *Doc_Webview;

@end
