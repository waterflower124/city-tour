//
//  CBTermsAndConditionsViewController.m
//  CityBud
//
//  Created by Mohit Garg on 22/03/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBTermsAndConditionsViewController.h"
#import "AppDelegate.h"

@interface CBTermsAndConditionsViewController () {
    
    AppDelegate *appdel;
}

@end

@implementation CBTermsAndConditionsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if(_isPrivacy){
        labelEventName.text = @"Privacy";
//        labelContent.text = @"The types of personal information that Wiley collects directly from you may include- Contact details, such as your name, email address, postal address and telephone number;        IP addresses;Educational and professional interests and background information;Usernames and passwords;        Payment information, such as a credit or debit card number;        Comments, feedback, posts and other content you submit to a Wiley service; and        Communication preferences.";
        
        
    }else{
        labelEventName.text = @"Terms & Conditions";
    }
    
    
     
    NSURL *URL;
    
    if ([appdel.ValueStr isEqualToString:@"Privacy"]) {
        
        URL = [[NSBundle mainBundle] URLForResource:@"PrivacyPolicy" withExtension:@"docx"];
        
        labelEventName.text = @"Privacy Policy";
    }

    if ([appdel.ValueStr isEqualToString:@"Terms"]) {
        
        URL = [[NSBundle mainBundle] URLForResource:@"TermsConditions" withExtension:@"docx"];
        
        labelEventName.text = @"Terms & Conditions";
    }
    
    
    if (URL) {
        
        //_Doc_Webview.frame = self.view.bounds;
        _Doc_Webview.scalesPageToFit = true;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [_Doc_Webview loadRequest:request];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBackButton:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
