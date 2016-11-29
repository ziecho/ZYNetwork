//
//  NSObject+ZYNetwork.m
//  ZYNetworkDemo
//
//  Created by zie on 16/9/3.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import "NSObject+ZYNetwork.h"
#import "ZYNetworkApi.h"
#import "ZYNetworkAgent.h"
#import <objc/message.h>
@implementation NSObject (ZYNetwork)
@dynamic zy_request;
- (void)deallocHandler
{
    NSMutableArray *requestApis = objc_getAssociatedObject(self, @selector(addRequestID:));
    if (requestApis) {
        for (NSNumber *requestID in requestApis) {
            [[ZYNetworkAgent sharedInstance] cancelRequestWithRequestID:requestID];
        }
    }
    [self deallocHandler];
    
}


//static void * requestApisKey = "requestApisKey";
//static void * deallocHasSwizzledKey = "deallocHasSwizzledKey";
- (void)addRequestID:(NSNumber *)requestID
{
    if (requestID) {
        NSMutableArray *requestApis = objc_getAssociatedObject(self, _cmd);
        if (!requestApis) {
            requestApis = @[].mutableCopy;
            objc_setAssociatedObject(self, _cmd, requestApis, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [requestApis addObject:requestID];
    }
}

- (void)hookDeallocMethod
{
    Class swizzleClass = [self class];

    BOOL hookFlag =  [objc_getAssociatedObject(swizzleClass, _cmd) boolValue];
    
    if (!hookFlag) {
        SEL systemSel = sel_registerName("dealloc");
        SEL mySel = @selector(deallocHandler);
        Method systemMethod = class_getInstanceMethod(swizzleClass,systemSel);
        Method myMethod = class_getInstanceMethod(swizzleClass,mySel);//本类方法
        
        //添加自定义的 delloc 处理 方法
        class_addMethod(swizzleClass, @selector(deallocHandler), method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
        myMethod = class_getInstanceMethod(swizzleClass, mySel); //被添加的子类方法
        //判断本来是否已经实现了 delloc 方法
        if(class_addMethod(swizzleClass, systemSel, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)))
            class_replaceMethod(swizzleClass, mySel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        else{
            //如果已经实现 直接交换
            method_exchangeImplementations(systemMethod, myMethod);
        }
        
        //增加hook flag
        objc_setAssociatedObject(swizzleClass, _cmd, @1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    
}


- (ZYNetworkManager *(^)(id))zy_request {
    return ^(id req) {
        ZYNetworkManager *mgr = [ZYNetworkManager new];
        if ([req isKindOfClass:[ZYNetworkApi class]]) {
            mgr.api = req;
        }
        else if ([req isKindOfClass:[NSString class]]) {
            mgr.api = [ZYNetworkApi apiWithUrl:req];;
        }
        else {
            NSAssert(0, @"Requested object must be a instance object of ‘ZYNetworkApi’ or URL string");
        }

        [mgr.api setValue:self forKey:@"requester"];
        [self hookDeallocMethod];
        return mgr;
    };
}
@end

