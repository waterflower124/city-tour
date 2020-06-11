//
//  CBGalleryViewController.h
//  CityBud
//
//  Created by Mohit Garg on 17/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBGalleryViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>{

    __weak IBOutlet UILabel *labelTitle;

    
}

@property (nonatomic,strong) NSDictionary *dictgallery;

- (IBAction)actionBackButton:(UIButton *)sender;


@end
