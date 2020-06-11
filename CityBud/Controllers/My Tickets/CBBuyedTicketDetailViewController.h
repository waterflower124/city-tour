//
//  CBBuyedTicketDetailViewController.h
//  CityBud
//
//  Created by Vikas Singh on 04/10/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBBuyedTicketDetailViewController : UIViewController
{
    IBOutlet UIImageView *imageViewEvent;
    IBOutlet UILabel *labelDate;
    IBOutlet UILabel *labelEventAddress;
    IBOutlet UILabel *refrenceNumber;
    IBOutlet UILabel *numberOfTicket;
    IBOutlet UILabel *totalPrice;
    IBOutlet NSLayoutConstraint *tableHeight;
    IBOutlet UIButton * BackButton;
    
    IBOutlet UITableView *TicketListTable;
}

@property (strong, nonatomic) NSMutableDictionary * TicketDetailDict;
@end
