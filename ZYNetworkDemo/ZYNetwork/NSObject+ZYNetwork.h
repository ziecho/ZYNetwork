//
//  NSObject+ZYNetwork.h
//  ZYNetworkDemo
//
//  Created by zie on 16/9/3.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYNetworkManager.h"
#import "ZYNetworkApi.h"
#import "ZYNetworkAgent.h"
@interface NSObject (ZYNetwork)
@property (nonatomic, copy) ZYNetworkManager* (^zy_request)(id);
- (void)addRequestID:(NSNumber *)requestID;

@end

