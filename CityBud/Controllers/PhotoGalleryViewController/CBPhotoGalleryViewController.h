//
//  CBPhotoGalleryViewController.h
//  CityBud
//
//  Created by Mohit Garg on 16/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPhotoGalleryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{

    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UITableView *tableGallery;
    __weak IBOutlet UICollectionView *collectionView;
    
    __weak IBOutlet UIButton *btnBack;
    __weak IBOutlet UIButton *btnForward;
}

@property (nonatomic,strong) NSDictionary *dictgallery;
@property (nonatomic) NSInteger currentIndex;

- (IBAction)actionBackButton:(UIButton *)sender;


@end
