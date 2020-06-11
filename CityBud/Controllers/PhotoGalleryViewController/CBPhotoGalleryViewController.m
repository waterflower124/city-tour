//
//  CBPhotoGalleryViewController.m
//  CityBud
//
//  Created by Mohit Garg on 16/02/17.
//  Copyright © 2018 iGlobsyn Technologies. All rights reserved.
//

#import "CBPhotoGalleryViewController.h"
#import "CBGalleryTableViewCell.h"
#import "CBGalleryCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CBPhotoGalleryViewController ()

@end

@implementation CBPhotoGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"check data%@", _dictgallery);
    labelTitle.text = _dictgallery[@"event_name"];
    
    [self setupSlideButtons];
}

- (void)viewWillLayoutSubviews {
    [collectionView reloadData];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSlideButtons {
    if (self.currentIndex == 0) {
        [btnBack setHidden:YES];
    } else if (self.currentIndex == [_dictgallery[@"gallery"] count]) {
        [btnForward setHidden:YES];
    } else {
        [btnBack setHidden:NO];
        [btnForward setHidden:NO];
    }
}

- (IBAction)actionBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showBackPhoto:(id)sender {
    self.currentIndex -= 1;
    [self setupSlideButtons];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (IBAction)showNextPhoto:(id)sender {
    self.currentIndex += 1;
    [self setupSlideButtons];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - TableView Delegate Methods...
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dictgallery[@"gallery"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *simpleTableIdentifier = @"CBGalleryTableViewCell";
        CBGalleryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[CBGalleryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
    
    
    [cell.galleryImage sd_setImageWithURL:[NSURL URLWithString:[_dictgallery[@"gallery"][indexPath.row] valueForKey:@"event_image"]]
                 placeholderImage:[UIImage imageNamed:@"logo_small"] options:SDWebImageRefreshCached];

        return cell;
 
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 165;
}*/


#pragma mark - Collection View Delegate and Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dictgallery[@"gallery"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CBGalleryCollectionViewCell" forIndexPath:indexPath];
    [cell.galleryImage sd_setImageWithURL:[NSURL URLWithString:[_dictgallery[@"gallery"][indexPath.row] valueForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"logo_small"] options:SDWebImageRefreshCached];
    
    return cell;
}

#pragma mark - Collection View Delegate Flowlayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    return CGSizeMake(screenSize.width, collectionView.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

@end
