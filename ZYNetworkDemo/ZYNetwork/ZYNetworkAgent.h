//
//  ZYNetworkAgent.h
//  ZYNetworkDemo
//
//  Created by zie on 16/9/18.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYNetworkApi.h"



@interface ZYNetworkAgent : NSObject
+ (ZYNetworkAgent *)sharedInstance;
- (NSNumber *)requestWithApi:(ZYNetworkApi *)api;
- (BOOL)cancelRequestWithRequestID:(NSNumber *)requestID;
@end


