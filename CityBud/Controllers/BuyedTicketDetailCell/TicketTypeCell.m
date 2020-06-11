//
//  TicketTypeCell.m
//  CityBud
//
//  Created by Vikas Singh on 05/07/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "TicketTypeCell.h"
#import "STMethod.h"

@implementation TicketTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (IS_IPHONE4_OR_4S)
    {
        
    }
    else if (IS_IPHONE5_OR_5S)
    {
        _checkBtnRightSide.constant = 25;
    }
    else if (IS_IPHONE6)
    {
        
    }
    else if (IS_IPHONE6pluse)
    {
        _titlelblLesftSide.constant = 60;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
