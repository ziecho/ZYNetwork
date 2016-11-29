//
//  APIManager.m
//  ZYNetworkDemo
//
//  Created by zie on 16/9/3.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager
+ (ZYNetworkApi *)loginWithUserName:(NSString *)user password:(NSString *)pwd {
    ZYNetworkApi *api = [ZYNetworkApi apiWithUrl:@"http://httpbin.org/post"];
    NSDictionary *param = @{@"user":user,
                            @"pwd":pwd
                            };
    api.parameters = param;
    api.requestType = ZYRequestMethodPost;
    api.timeoutInterval = 1;
    return api;
}


+ (ZYNetworkApi *)weatherApi {
    ZYNetworkApi *api = [ZYNetworkApi new];
    api.requestUrl = @"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json";
    return api;
}

@end
