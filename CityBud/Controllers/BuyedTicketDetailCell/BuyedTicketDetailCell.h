//
//  BuyedTicketDetailCell.h
//  CityBud
//
//  Created by Vikas Singh on 04/10/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyedTicketDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel * TicketCategorylabel;
@property (strong, nonatomic) IBOutlet UITextField * numberofTicket;
@property (strong, nonatomic) IBOutlet UITextField *  totalPrice;

@end
