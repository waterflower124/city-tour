//
//  CBSearchResultViewController.h
//  CityBud
//
//  Created by Mohit Garg on 02/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSearchResultViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>{

    __weak IBOutlet UILabel *labelCityName;
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UITableView *tableResultEvent;
}

- (IBAction)actionBackButton:(UIButton *)sender;

@property (nonatomic, strong) NSMutableArray *arrSearchResult;
@property (nonatomic, strong) NSMutableDictionary *dictSearchParameter;
@property (nonatomic, strong) NSString *eventType;
@property (assign) BOOL isFromAccount;
@property (assign) BOOL isEvent;
@property (assign) BOOL isVenue;
@property (assign) BOOL SearchUsingDate;
@end
