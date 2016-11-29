//
//  ZYNetworkAgent.m
//  ZYNetworkDemo
//
//  Created by zie on 16/9/18.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import "ZYNetworkAgent.h"
#import <AFNetworking.h>
#import <objc/message.h>

static NSTimeInterval kZYNetworkTimeoutInterval = 5.0f;
@interface ZYNetworkAgent()
@property (nonatomic ,strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@end
@implementation ZYNetworkAgent

- (void)dealloc {
    NSLog(@"%s",__func__);
}

+ (ZYNetworkAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



- (NSURLRequest *)generateRequestWithApi:(ZYNetworkApi *)api {
    //self.api = api;
    NSError *error;
    NSMutableURLRequest *request;
    if (api.requestType == ZYRequestMethodGet) {
        request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:api.requestUrl parameters:api.parameters error:&error];
    } else if (api.requestType == ZYRequestMethodPost) {
        request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:api.requestUrl parameters:api.parameters error:&error];
    }
    if (api.timeoutInterval != 0) {
        request.timeoutInterval = api.timeoutInterval;
    }
    
    return request;
}



- (NSNumber *)requestWithApi:(ZYNetworkApi *)api {
   // return nil;
    NSURLRequest *request = [self generateRequestWithApi:api];
    AFURLSessionManager *sessionManager = self.sessionManager;

    __block NSURLSessionDataTask *task = [sessionManager
                                  dataTaskWithRequest:request
                                  uploadProgress:nil
                                  downloadProgress:nil
                                  completionHandler:^(NSURLResponse * _Nonnull response,
                                                      id  _Nullable responseObject,
                                                      NSError * _Nullable error)
                                  {//网络回调
     
                                      [self callCompletionAccessoryMethodWithApi:api responseObject:responseObject error:error];
                                      
                                      NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
                                      BOOL isCanceled = ![self cancelRequestWithRequestID:requestID];
                                      if (isCanceled) return;
                                      if (api.requester) {
                                          if (api.completionBlock) {
                                              api.completionBlock(responseObject,error);
                                          }
                                          if (api.successCompletionBlock && !error) {
                                              api.successCompletionBlock(responseObject);
                                          }
                                          else if (api.failureCompletionBlock && error) {
                                              api.failureCompletionBlock(error);
                                          }
                                      }
                                  }];
    [self callBeginAccessoryMethodWithApi:api];
    [task resume];
    NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
    [self.dispatchTable setObject:task forKey:requestID];
    return requestID;
}

- (BOOL)cancelRequestWithRequestID:(NSNumber *)requestID{
    NSURLSessionDataTask *task = [self.dispatchTable objectForKey:requestID];
    if (task) {
        [task cancel];
        [self.dispatchTable removeObjectForKey:requestID];
        return YES;
    }
    return NO;
}
#pragma mark - request Accessory 回调方法

- (void)callCompletionAccessoryMethodWithApi:(ZYNetworkApi *)api responseObject:(id)responseObject error:(NSError *) error {
    
    if (api.requesterCanReceiveAccessoryMethod && [api.requester respondsToSelector:@selector(networkApiCompletieRequest:withResponse:error:)]) {
        SEL completieSel = @selector(networkApiCompletieRequest:withResponse:error:);
        NSMethodSignature *signature= [[api.requester class]  instanceMethodSignatureForSelector:completieSel];
        
        if (!signature) return;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = api.requester;
        invocation.selector = completieSel;
        [invocation setArgument:&api atIndex:2];
        [invocation setArgument:&responseObject atIndex:3];
        [invocation setArgument:&error atIndex:4];
        [invocation invoke];
    }
}

- (void)callBeginAccessoryMethodWithApi:(ZYNetworkApi *)api {
    if (api.requesterCanReceiveAccessoryMethod && [api.requester respondsToSelector:@selector(networkApiStartRequest:)]) {
        [api.requester performSelector:@selector(networkApiStartRequest:) withObject:api];
    }
}
#pragma mark - getters and setters

- (AFURLSessionManager *)getCommonSessionManager
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForResource = 20;
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return sessionManager;
}


- (AFURLSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [self getCommonSessionManager];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _sessionManager;
}


- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kZYNetworkTimeoutInterval;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

- (NSMutableDictionary *)dispatchTable{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}


@end







