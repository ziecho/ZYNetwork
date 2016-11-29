//
//  ZYNetworkManager.m
//  ZYNetworkDemo
//
//  Created by zie on 16/9/3.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import "ZYNetworkManager.h"
#import "ZYNetworkAgent.h"
#import "NSObject+ZYNetwork.h"
#import <AFNetworking.h>
@implementation ZYNetworkManager


#pragma mark - 点语法的 getter 方法
- (ZYNetworkManager *(^)(CompletionDataBlock))success {
    return ^(CompletionDataBlock success){
        return [self setCompletionSuccessBlock:success];
    };
}

- (ZYNetworkManager *(^)(CompletionErrorBlock))failure {
    return ^(CompletionErrorBlock failure){
        return [self setCompletionFailureBlock:failure];
    };
}

- (ZYNetworkManager *(^)(CompletionBlock))completion {
    return ^(CompletionBlock completion){
        return [self setCompletionBlock:completion];
    };
}


#pragma mark - 对 block 赋值方法

- (ZYNetworkManager *)setCompletionSuccessBlock:(CompletionDataBlock)success {
    ;
    self.api.successCompletionBlock = success;
    
    return self;
}

- (ZYNetworkManager *)setCompletionFailureBlock:(CompletionErrorBlock)failure {
    self.api.failureCompletionBlock = failure;
    return self;
}


- (ZYNetworkManager *)setCompletionBlock:(CompletionBlock)completion {
    self.api.completionBlock = completion;
    return self;
}

#pragma mark - 开始进行网络请求
- (NSNumber * (^)())resume {
    return ^{
        NSNumber *requestID = [[ZYNetworkAgent sharedInstance] requestWithApi:self.api];
        [self.api.requester addRequestID:requestID];
        return requestID;
    };
}

@end
