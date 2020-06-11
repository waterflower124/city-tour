//
//  CBSearchResultTableViewCell.h
//  CityBud
//
//  Created by Mohit Garg on 02/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSearchResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgEvent;


@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;


@property (weak, nonatomic) IBOutlet UIView *viewCenterContainer;
@property (weak, nonatomic) IBOutlet UILabel *labelCenterName;
@property (weak, nonatomic) IBOutlet UILabel *labelCenterAddress;


@property (weak, nonatomic) IBOutlet UIView *viewBottomContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblEventName;
@property (weak, nonatomic) IBOutlet UILabel *lblEventPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblEventAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblEventCity;

@property (weak, nonatomic) IBOutlet UIImageView *imageFeaturedStar;


@end
