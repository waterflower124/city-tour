//
//  PFHTTPClient.m
//  PrimeFit
//
//  Created by Ajay Chaudhary on 4/10/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//

#import "WDHTTPClient.h"
#import "AFNetworkActivityIndicatorManager.h"

static NSString * const BaseURL = BaseLink;

@implementation WDHTTPClient

+ (instancetype)sharedClient {
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    static WDHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WDHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
        _sharedClient.responseSerializer.acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//        _sharedClient.responseSerializer set
        [_sharedClient.requestSerializer setTimeoutInterval:180];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
