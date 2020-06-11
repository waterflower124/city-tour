//
//  PFHTTPClient.h
//  PrimeFit
//
//  Created by Ajay Chaudhary on 4/10/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface WDHTTPClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
