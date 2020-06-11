//
//  PhotosViewFlowLayout.m
//  Travel App
//
//  Created by iGlobsyn on 09/09/2017.
//  Copyright © 2017 iGlobsyn Technologies. All rights reserved.
//

#import "PhotosViewFlowLayout.h"


@implementation PhotosViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.minimumLineSpacing = 1.0;
        self.minimumInteritemSpacing = 1.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (CGSize)itemSize
{
    NSInteger numberOfColumns = 3;
    
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - (numberOfColumns - 1)) / numberOfColumns;
    
    return CGSizeMake(itemWidth, itemWidth);
}


@end
