//
//  TestViewController.m
//  ZYNetworkDemo
//
//  Created by zie on 16/9/19.
//  Copyright © 2016年 ziecho. All rights reserved.
//

#import "TestViewController.h"
#import "APIManager.h"
#import "NSObject+ZYNetwork.h"
@interface TestViewController ()<ZYNetworkApiRequestAccessory>
@property (nonatomic ,strong) ZYNetworkApi *myApi;
@end

@implementation TestViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo1];
    
}



- (void)demo1 {
    //方式一：通过 APIManager 生成一个 API
    
    ZYNetworkApi *api = [APIManager loginWithUserName:@"test01" password:@"123456"];
    //
    self.zy_request(api).success(^(id data){
        NSLog(@"%@",data);
    }).failure(^(NSError *err){
        
    }).resume();
    
    /* completion */
    self.zy_request(api).completion(^(id data, NSError *error) {
        
    }).resume();
    
    
}

- (void)demo2 {
    //    //方式二：直接请求网址
    self.zy_request(@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json").completion(^(id data,NSError *err){
        NSLog(@"%@",data);
    }).resume();
}


- (void)demo3 {
    //方式三：懒加载
    self.zy_request(self.myApi).completion(^(id data,NSError *err){
        if (!err) {
             NSLog(@"%@",data);
        } else {
           NSLog(@"出错啦：\n%@",err);
        }
    }).resume();
}





- (void)networkApiStartRequest:(ZYNetworkApi *)api {
    
    NSLog(@"开始--------");
    //在这里可以统一设置HUD
}

- (void)networkApiCompletieRequest:(ZYNetworkApi *)api withResponse:(id)response error:(NSError *)error {
    NSLog(@"请求完毕--------");
    //在这里可以统一隐藏HUD
}





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (ZYNetworkApi *)myApi {
    //测试超时
    if (!_myApi) {
        _myApi = [ZYNetworkApi apiWithUrl:@"http://58.241.41.149/niotdoc/html/xtc/index.html"];
        _myApi.timeoutInterval = 3;
    }
    return _myApi;
}

@end
