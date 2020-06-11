//
//  MyTicketListCell.m
//  CityBud
//
//  Created by Vikas Singh on 04/10/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "MyTicketListCell.h"
#import "STMethod.h"

@implementation MyTicketListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
  [STMethod setViewRoundRectAndBorderViewAndShadow:_ImageBaseView CornerRadius:35.0 Round:true BorderWidth:2.0 BorderColor:[UIColor colorWithRed:29.0/255.0 green:79.0/255.0 blue:131.0/255.0 alpha:1.0] ShadowOrNot:false ShadowColor:[UIColor clearColor] ShadowOpacity:0.6 ShadowRadius:5.0 ShadowOffset:CGSizeMake(0.0, 0.0)];
    
    [STMethod setViewRoundRectAndBorderViewAndShadow:_BaseView CornerRadius:10.0 Round:true BorderWidth:0.0 BorderColor:[UIColor clearColor] ShadowOrNot:true ShadowColor:[UIColor grayColor] ShadowOpacity:0.6 ShadowRadius:5.0 ShadowOffset:CGSizeMake(0.0, 0.0)];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
