//
//  PayStackPayController.h
//  CityBud
//
//  Created by Apple on 25/04/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Paystack/Paystack.h>


@interface PayStackPayController : UIViewController<PSTCKPaymentCardTextFieldDelegate>
{
    NSString * transactionID;
    
     IBOutlet NSLayoutConstraint * upper_height;
    
}
@property(nonatomic)IBOutlet PSTCKPaymentCardTextField *paymentTextField;
@property(nonatomic)IBOutlet UIButton *PayButton;
@property (strong, nonatomic) NSMutableArray * PaymentDetailArr;
@property (strong, nonatomic) NSString * eventID;
@end
