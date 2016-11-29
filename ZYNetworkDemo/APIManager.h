//
//  APIManager.h
//  ZYNetworkDemo
//
//  Created by zie on 16/9/3.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYNetworkApi.h"
@interface APIManager : NSObject
+ (ZYNetworkApi *)loginWithUserName:(NSString *)user password:(NSString *)pwd;
+ (ZYNetworkApi *)weatherApi;
@end
