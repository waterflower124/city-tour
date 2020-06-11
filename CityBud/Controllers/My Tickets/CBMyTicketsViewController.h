//
//  CBMyTicketsViewController.h
//  CityBud
//
//  Created by Vikas Singh on 04/07/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBMyTicketsViewController : UIViewController
{
    NSMutableArray * ticketHistoryDict;
}

@property (strong, nonatomic)  IBOutlet UITableView * TicketHistoryListTable;

@end
