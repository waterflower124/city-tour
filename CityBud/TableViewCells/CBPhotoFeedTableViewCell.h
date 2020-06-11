//
//  CBPhotoFeedTableViewCell.h
//  CityBud
//
//  Created by Mohit Garg on 04/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPhotoFeedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageGallery;
@property (weak, nonatomic) IBOutlet UILabel *labelGalleryName;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;

@end
