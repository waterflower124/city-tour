//
//  TicketTypeCell.h
//  CityBud
//
//  Created by Vikas Singh on 05/07/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketTypeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel * TicketCategorylabel;
@property (strong, nonatomic) IBOutlet UITextField * numberofTicket;
@property (strong, nonatomic) IBOutlet UITextField *  totalPrice;
@property (strong, nonatomic) IBOutlet UIButton * checkboxBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint * titlelblLesftSide;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint * checkBtnRightSide;

@end
