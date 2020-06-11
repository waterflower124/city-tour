//
//  CBGetTicketViewController.h
//  CityBud
//
//  Created by Vikas Singh on 19/06/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBGetTicketViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet NSLayoutConstraint *tableHeight;
    IBOutlet UITableView * ticketTypeTable;
    NSString * TicketCategoryType;
    NSInteger TicketSelectOptionHeight;
    NSMutableArray * DropdownArr;
    IBOutlet UIButton * payStackButton;
    NSMutableDictionary * ticketPriceUpdateDict;
}

@property (assign) NSMutableDictionary * dictParamForGetTicket;
@property (nonatomic, strong) NSMutableArray *arrSearchResult;

@end
