//
//  MyTicketListCell.h
//  CityBud
//
//  Created by Vikas Singh on 04/10/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTicketListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView * BaseView;
@property (strong, nonatomic)  IBOutlet UILabel * EventName;
@property (strong, nonatomic)  IBOutlet UILabel * EventAddress;
@property (strong, nonatomic)  IBOutlet UILabel * NoofTicket;
@property (strong, nonatomic)  IBOutlet UILabel * TotalPrice;
@property (strong, nonatomic)  IBOutlet UILabel * EventDateDay;
@property (strong, nonatomic)  IBOutlet UILabel * EventDateYear;
@property (strong, nonatomic)  IBOutlet UIImageView * EventImage;
@property (strong, nonatomic) IBOutlet UIImageView *TicketBgImageView;

@property (strong, nonatomic) IBOutlet UIView * ImageBaseView;

@end
