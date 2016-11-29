//
//  ZYNetworkManager.h
//  ZYNetworkDemo
//
//  Created by zie on 16/9/3.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYNetworkApi.h"





@interface ZYNetworkManager : NSObject
//typedef void (^CompletionDataBlock)(id data);
//typedef void (^CompletionErrorBlock)(NSError *error);
//typedef void (^CompletionBlock)(id data,NSError *error);
@property (nonatomic, copy) ZYNetworkApi *api; //使用copy 是为了防止污染原来的api
@property (nonatomic, copy) NSNumber *(^resume)();
@property (nonatomic, copy) ZYNetworkManager *(^loadingText)(NSString *);
@property (nonatomic, copy) ZYNetworkManager *(^alertType)(NSUInteger);
@property (nonatomic, copy) ZYNetworkManager *(^success)(CompletionDataBlock);
@property (nonatomic, copy) ZYNetworkManager *(^failure)(CompletionErrorBlock);
@property (nonatomic, copy) ZYNetworkManager *(^completion)(CompletionBlock);
@end
