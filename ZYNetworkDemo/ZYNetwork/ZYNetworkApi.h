//
//  ZYNetworkApi.h
//  ZYNetworkDemo
//
//  Created by zie on 16/9/6.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , ZYRequestMethod) {
    ZYRequestMethodGet,
    ZYRequestMethodPost
};


typedef NS_ENUM(NSInteger, ZYRequestErrorTipsType) {
    ZYRequestErrorTipsTypeNone     = 100,
    ZYRequestErrorTipsTypeToast    = 101,
    ZYRequestErrorTipsTypeAlert    = 102,
    ZYRequestErrorTipsTypeView     = 203
};

typedef NS_ENUM(NSInteger, ZYRequestLoadingTipsType) {
    ZYRequestLoadingTipsTypeNone           = 200,
    ZYRequestLoadingTipsTypeHUD            = 201,
    ZYRequestLoadingTipsTypeView           = 202,
};


typedef void (^CompletionDataBlock)(id data);
typedef void (^CompletionErrorBlock)(NSError *error);
typedef void (^CompletionBlock)(id data, NSError *error);



@interface ZYNetworkApi : NSObject

/**
 *  网络请求参数
 */
@property (nonatomic, copy) NSString *requestUrl;              //网络请求地址
@property (nonatomic, strong) NSDictionary *parameters;             //请求参数
@property (nonatomic, assign) ZYRequestMethod requestType;  //网络请求方式
@property (nonatomic, assign) NSTimeInterval timeoutInterval; //超时时间
@property (nonatomic, assign) NSInteger errorTipsType;
@property (nonatomic, assign) NSInteger loadingTipsType;
@property (nonatomic, copy) CompletionBlock completionBlock;
@property (nonatomic, copy) CompletionDataBlock successCompletionBlock;
@property (nonatomic, copy) CompletionErrorBlock failureCompletionBlock;
@property (nonatomic, readonly, weak) id requester;
@property (nonatomic, assign) BOOL requesterCanReceiveAccessoryMethod; //是否将网络请求状态通知 requester
+ (instancetype)apiWithUrl:(NSString *)url;

@end


@protocol ZYNetworkApiRequestAccessory <NSObject>
@optional
- (void)networkApiStartRequest:(ZYNetworkApi *)api;
- (void)networkApiCompletieRequest:(ZYNetworkApi *)api withResponse:(id)response error:(NSError *)error;
@end
