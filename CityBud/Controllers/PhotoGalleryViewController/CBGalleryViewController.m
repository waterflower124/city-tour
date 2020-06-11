//
//  CBGalleryViewController.m
//  CityBud
//
//  Created by Mohit Garg on 17/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBGalleryViewController.h"
#import "CBGalleryCollectionViewCell.h"
#import "CBPhotoGalleryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CBGalleryViewController ()

@end

@implementation CBGalleryViewController
    
   

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    labelTitle.text = _dictgallery[@"event_name"];
}

-(void)viewDidAppear:(BOOL)animated {
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;//MFSideMenuPanModeDefault

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma marl - collection view delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dictgallery[@"gallery"] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"collectionCell";
    
    CBGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.galleryImage sd_setImageWithURL:[NSURL URLWithString:[_dictgallery[@"gallery"][indexPath.row] valueForKey:@"event_image"]]
                         placeholderImage:[UIImage imageNamed:@"logo_small"]];
    
    cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0 );
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(((collectionView.frame.size.width)/3)-8, ((collectionView.frame.size.width)/3)-8);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"segueDetailImage" sender:indexPath];
    
}
- (IBAction)actionBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"segueDetailImage"]) {
        
        CBPhotoGalleryViewController *photoVC = [segue destinationViewController];
        photoVC.dictgallery = _dictgallery;
        photoVC.currentIndex = ((NSIndexPath *)sender).row;
    }
    
}

@end
