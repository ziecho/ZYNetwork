//
//  ZYNetworkApi.m
//  ZYNetworkDemo
//
//  Created by zie on 16/9/6.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import "ZYNetworkApi.h"
#import <objc/message.h>
@interface ZYNetworkApi () <NSCopying>
@end

@implementation ZYNetworkApi

- (instancetype)init{
    self = [super init];
    if (self) {
        _requestType = ZYRequestMethodGet;//默认为 GET 请求
        _loadingTipsType = ZYRequestLoadingTipsTypeHUD; //默认提示类型为HUD
        _errorTipsType = ZYRequestErrorTipsTypeToast;  //默认提示类型为 Toast
        _requesterCanReceiveAccessoryMethod = YES;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s -> %@",__func__,_requester);
   
}


+ (instancetype)apiWithUrl:(NSString *)url {
    ZYNetworkApi *api = [[ZYNetworkApi alloc] init];
    api.requestUrl = url;
    return api;
}


- (id)copyWithZone:(NSZone *)zone
{
    ZYNetworkApi *api = [[[self class] allocWithZone:zone] init];
    api.requestUrl = _requestUrl;
    api.successCompletionBlock = _successCompletionBlock;
    api.failureCompletionBlock = _failureCompletionBlock;
    api.completionBlock = _completionBlock;
    api.parameters = _parameters;
    api.requestType = _requestType;
    api.timeoutInterval = _timeoutInterval;
    api.requesterCanReceiveAccessoryMethod = _requesterCanReceiveAccessoryMethod;
    api.loadingTipsType = _loadingTipsType;
    api.errorTipsType = _errorTipsType;
    return api;
}



@end
