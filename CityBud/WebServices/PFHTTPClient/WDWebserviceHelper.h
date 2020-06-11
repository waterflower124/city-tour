//
//  ADWebserviceHelper.h
//  AFDemo
//
//  Created by Ajay Chaudhary on 4/10/16.
//  Copyright © 2016 Imvisile Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark WebserviceInputParameter

enum _webserviceMethodType
{
    WEBSERVICE_METHOD_TYPE_GET,
    WEBSERVICE_METHOD_TYPE_POST,
    WEBSERVICE_METHOD_TYPE_DELETE,
    WEBSERVICE_METHOD_TYPE_PUT
};
typedef enum _webserviceMethodType WebserviceMethodType;

@interface WebserviceInputParameter : NSObject

@property (nonatomic, copy) NSString *webserviceRelativePath;
@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, strong) NSMutableDictionary *dictGetParameters;
@property (nonatomic, strong) NSMutableDictionary *dictPostParameters;
@property (nonatomic, strong) NSMutableDictionary *dictDeleteParameters;
@property (nonatomic, strong) NSData *dataParameters;
@property (nonatomic, strong) NSArray *arrayMedia;

@property (nonatomic, assign) WebserviceMethodType serviceMethodType;
@property (nonatomic, assign) BOOL shouldShowLoadingActivity;
@property (nonatomic, assign) BOOL shouldShowNoNetworkAlert;

@end

#pragma mark ADWebserviceHelper

typedef void (^successBlock)(id response, NSError *error);
typedef void (^errorBlock)(id reponse, NSError *error);

@interface WDWebserviceHelper : NSObject

+(void) callWebserviceWithInputParameter:(WebserviceInputParameter *)inputParameter
                                 success:(successBlock)blkSuccess
                                   error:(errorBlock)blkError;

+(void) callMultiPartRequestWithInputParameter:(WebserviceInputParameter *)inputParameter
                                     mediaType:(NSString *)mediaType
                                       success:(successBlock)blkSuccess
                                         error:(errorBlock)blkError;
//+(void) callMultiPartRequestWithParameter:(WebserviceInputParameter *)inputParameter
//                                     data: (NSData *)dataMultiPart
//                                  success:(successBlock)blkSuccess
//                                    error:(errorBlock)blkError;

@end
