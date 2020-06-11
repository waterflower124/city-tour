//
//  CBHomeViewController.h
//  CityBud
//
//  Created by Vikas Singh on 25/01/18.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBHomeViewController : UIViewController<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    
    
    __weak IBOutlet NSLayoutConstraint *constraintViewDropDown;
    __weak IBOutlet NSLayoutConstraint *constraintTableViewTop;
    
    __weak IBOutlet UIButton *buttonEventsNearMe;
    __weak IBOutlet UIButton *buttonThisWeek;
    __weak IBOutlet UIButton *buttonEventType;
    
    __weak IBOutlet UITableView *tableViewEvents;
    
    __weak IBOutlet UIView *viewDropDownTop;
    __weak IBOutlet UIView *viewDropDown;
    
    __weak IBOutlet UIButton *buttonAllEvents;
    __weak IBOutlet UIButton *buttonNightlife;
    __weak IBOutlet UIButton *buttonEducation;
    __weak IBOutlet UIButton *buttonSports;
    __weak IBOutlet UIButton *buttonFestivals;
    __weak IBOutlet UIButton *buttonReligious;
    
    
    __weak IBOutlet UILabel *labelUnderNearMe;
    __weak IBOutlet UILabel *labelUnderWeek;
    
    __weak IBOutlet UIButton *buttonCreateEvent;
    
    
}
@property (weak, nonatomic) IBOutlet UIView *viewTopTitles;
@property (weak, nonatomic) IBOutlet UIView *viewTopButtons;

@property (weak, nonatomic) IBOutlet UILabel *labelCityName;
@property (weak, nonatomic) IBOutlet UILabel *labelMenuSelectedName;

@property (assign) BOOL photo;
@property (assign) BOOL isEvent;

@end
