//
//  CBEventsTableViewCell.h
//  CityBud
//
//  Created by Ajay Chaudhary on 27/01/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CBEventsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewEvent;
@property (weak, nonatomic) IBOutlet UILabel *labelEventName;
@property (weak, nonatomic) IBOutlet UILabel *labelEventPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelEventAddress;
@property (weak, nonatomic) IBOutlet UILabel *lavelEventCity;
@property (weak, nonatomic) IBOutlet UIView *viewBottomContainer;

@property (weak, nonatomic) IBOutlet UIView *viewCenterContainer;
@property (weak, nonatomic) IBOutlet UILabel *labelCenterName;
@property (weak, nonatomic) IBOutlet UILabel *labelCenterAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imageFeaturedStar;

@end
