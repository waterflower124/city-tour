//
//  TagAnnotation.m
//  FindMe
//
//  Created by Ajay Chaudhary on 10/16/14.
//  Copyright (c) 2014 Apprizer. All rights reserved.
//

#import "TagAnnotation.h"

@implementation TagAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if(self = [super init])
        self.coordinate = coordinate;
    return self;
}

@end
