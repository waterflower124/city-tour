//
//  ADWebserviceHelper.m
//  AFDemo
//
//  Created by Ajay Chaudhary on 4/10/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//

#import "WDWebserviceHelper.h"

@implementation WebserviceInputParameter

#pragma mark WebserviceInputParameter
-(id) init
{
    self = [super init];
    
    if (self) {
        self.shouldShowLoadingActivity = YES;
        self.shouldShowNoNetworkAlert = YES;
    }
    
    return self;
}

-(NSMutableDictionary *) dictPostParameters
{
    if (!_dictPostParameters)
        _dictPostParameters = [[NSMutableDictionary alloc] init];
    
    return _dictPostParameters;
}

-(NSMutableDictionary *) dictGetParameters
{
    if (!_dictGetParameters)
        _dictGetParameters = [[NSMutableDictionary alloc] init];
    
    return _dictGetParameters;
}

-(NSMutableDictionary *) dictDeleteParameters
{
    if (!_dictDeleteParameters)
        _dictDeleteParameters = [[NSMutableDictionary alloc] init];
    
    return _dictDeleteParameters;
}


@end

#pragma mark ADWebserviceHelper

@implementation WDWebserviceHelper


+(NSString *) httpMethodTypeForServiceType:(WebserviceMethodType)type
{
    switch (type)
    {
        case WEBSERVICE_METHOD_TYPE_GET:
            return @"GET";
            break;
        case WEBSERVICE_METHOD_TYPE_POST:
            return @"POST";
            break;
        case WEBSERVICE_METHOD_TYPE_DELETE:
            return @"DELETE";
            break;
        
        default:
            break;
    }
    
    return @"GET";
}


+(void) callWebserviceWithInputParameter:(WebserviceInputParameter *)inputParameter
                                 success:(successBlock)blkSuccess
                                   error:(errorBlock)blkError
{
    __block successBlock localSuccessBlock = [blkSuccess copy];
    __block errorBlock localErrorBlock = [blkError copy];
    
    
    @try {
        
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            localErrorBlock(nil, [NSError noNetworkError]);
            localErrorBlock = nil;
            localSuccessBlock = nil;
            return;
        }
        
        if (inputParameter.shouldShowLoadingActivity) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //SHOW_LOADING();
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:SCREEN_WINDOW animated:YES];
                HUD.labelFont = [UIFont fontWithName:Helvetica size:18.0f];
                HUD.labelText = @"Loading...";
            });
        }
        
        
        switch (inputParameter.serviceMethodType)
        {
            case WEBSERVICE_METHOD_TYPE_GET:
            {
                [[WDHTTPClient sharedClient] GET:inputParameter.webserviceRelativePath parameters:inputParameter.dictGetParameters progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                    //NSLog(@"%@",downloadProgress);
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //return the response to success block with error nil...
                    localSuccessBlock(responseObject, nil);
                    localSuccessBlock = nil;
                    
                    if (inputParameter.shouldShowLoadingActivity) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            HIDE_LOADING();
                        });
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    //return the reposne to error block with response data nil...
                    localErrorBlock(nil, error);
                    localErrorBlock = nil;
                    localSuccessBlock = nil;
                    
                    if (inputParameter.shouldShowLoadingActivity) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            HIDE_LOADING();
                        });
                    }
                }];
            }
                break;
                
            case WEBSERVICE_METHOD_TYPE_POST:
            {

                [[WDHTTPClient sharedClient] POST:inputParameter.webserviceRelativePath parameters:inputParameter.dictPostParameters progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    //NSLog(@"%@",uploadProgress);

                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //return the response to success block with error nil...
                    localSuccessBlock(responseObject, nil);
                    localSuccessBlock = nil;
                    
                    if (inputParameter.shouldShowLoadingActivity) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            HIDE_LOADING();
                        });
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    //return the reposne to error block with response data nil...
                    localErrorBlock(nil, error);
                    localErrorBlock = nil;
                    localSuccessBlock = nil;
                    
                    if (inputParameter.shouldShowLoadingActivity) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            HIDE_LOADING();
                        });
                    }
                }];
            }
                break;
                
                
            case WEBSERVICE_METHOD_TYPE_DELETE:
            {
                [[WDHTTPClient sharedClient] DELETE:inputParameter.webserviceRelativePath parameters:inputParameter.dictDeleteParameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //return the response to success block with error nil...
                    localSuccessBlock(responseObject, nil);
                    localSuccessBlock = nil;
                    
                    if (inputParameter.shouldShowLoadingActivity) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            HIDE_LOADING();
                        });
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    //return the reposne to error block with response data nil...
                    localErrorBlock(nil, error);
                    localErrorBlock = nil;
                    localSuccessBlock = nil;
                    
                    if (inputParameter.shouldShowLoadingActivity) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            HIDE_LOADING();
                        });
                    }
                }];
            }
                break;
                
            default:
                break;
        }
        
    }
    @catch (NSException *exception)
    {
        
        if (inputParameter.shouldShowLoadingActivity) {
            dispatch_async(dispatch_get_main_queue(), ^{
                HIDE_LOADING();
            });
        }
        
        localErrorBlock(nil, [exception exceptionError]);
        localErrorBlock = nil;
        localSuccessBlock = nil;
        
    }
    @finally {
    }
}


+(void) callMultiPartRequestWithInputParameter:(WebserviceInputParameter *)inputParameter
                                     mediaType:(NSString *)mediaType
                                       success:(successBlock)blkSuccess
                                         error:(errorBlock)blkError
{
    __block successBlock localSuccessBlock = [blkSuccess copy];
    __block errorBlock localErrorBlock = [blkError copy];
    
    @try {
        
        if ([AFNetworkReachabilityManager sharedManager].reachable)
        {
            localErrorBlock(nil, [NSError noNetworkError]);
            localErrorBlock = nil;
            localSuccessBlock = nil;
            return;
        }
        
        if (inputParameter.shouldShowLoadingActivity)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:SCREEN_WINDOW animated:YES];
                HUD.labelFont = [UIFont fontWithName:Helvetica size:18.0f];
                HUD.labelText = @"Loading...";
            });
        }
        
        [[WDHTTPClient sharedClient] POST:inputParameter.webserviceRelativePath parameters:inputParameter.dictPostParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
            NSArray *imagarray = [inputParameter.arrayMedia mutableCopy];
            
            for (int i=0; i<imagarray.count; i++) {
                
                NSObject * dataObj = [imagarray objectAtIndex:i];
                
                if ([dataObj isKindOfClass:[UIImage class]])
                {
                    NSData *imageData = UIImageJPEGRepresentation(inputParameter.arrayMedia[i],0.5);
                    
                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
                    
                    
                    NSString * temp = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
                    
                    NSString *  fileNameStr= [NSString stringWithFormat:@"image_%@", temp];
                    
                    //name would be webservice parameter name for image event_pic1
                    
                    NSString *countstr = [NSString stringWithFormat:@"event_pic%d",i+1];
                    
                    [formData appendPartWithFileData:imageData name:countstr fileName:[fileNameStr stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
                    
                } else if ([dataObj isKindOfClass:[NSString class]]) {
                    
                }

            }
//            else{
//
//                NSString * imageName = (NSString *) dataObj;
//                imageName = [imageName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//
//                NSData* imageData = [imageName dataUsingEncoding:NSUTF8StringEncoding];
//
//                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//                [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
//
//
//                NSString * temp = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
//
//                NSString *  fileNameStr= [NSString stringWithFormat:@"image_%@", temp];
//
//                //name would be webservice parameter name for image event_pic1
//
//                NSString *countstr = [NSString stringWithFormat:@"event_pic%d",i+1];
//
//                [formData appendPartWithFileData:imageData name:countstr fileName:[fileNameStr stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
//
//            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //return the response to success block with error nil...
            localSuccessBlock(responseObject, nil);
            localSuccessBlock = nil;
            
            if (inputParameter.shouldShowLoadingActivity) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    HIDE_LOADING();
                });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //return the reposne to error block with response data nil...
            localErrorBlock(nil, error);
            localErrorBlock = nil;
            localSuccessBlock = nil;
            
            if (inputParameter.shouldShowLoadingActivity) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    HIDE_LOADING();
                });
            }
        }];
    }
    @catch (NSException *exception) {
        
        if (inputParameter.shouldShowLoadingActivity) {
            dispatch_async(dispatch_get_main_queue(), ^{
                HIDE_LOADING();
            });
        }
        
        localErrorBlock(nil, [exception exceptionError]);
        localErrorBlock = nil;
        localSuccessBlock = nil;
        
    }
    @finally {
    }
}



@end
