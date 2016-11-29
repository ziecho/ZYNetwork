# ZYNetwork
A network request library based on AFNetworking 3.0+
When the requester object is delloced, all requests it sends are automatically destroyed.

## 1. Request a URL
```objc
self.zy_request(@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json").completion(^(id data,NSError *err){
        NSLog(@"%@",data);
    }).resume();
```

## 2.Request a API
```objc
- (ZYNetworkApi *)loginWithUserName:(NSString *)user password:(NSString *)pwd {
    ZYNetworkApi *api = [ZYNetworkApi apiWithUrl:@"http://httpbin.org/post"];
    NSDictionary *param = @{@"user":user,
                            @"pwd":pwd
                            };
    api.parameters = param;
    api.requestType = ZYRequestMethodPost;
    api.timeoutInterval = 5;
    return api;
}

 ZYNetworkApi *api = [self loginWithUserName:@"test01" password:@"123456"];
 
  /* only success  */
    self.zy_request(api).success(^(id data){
        NSLog(@"%@",data);
    }).resume(); 
 
  /* success &&  failure */
    self.zy_request(api).success(^(id data){
        NSLog(@"%@",data);
    }).failure(^(NSError *err){
    }).resume();
    
   /* completion */
    self.zy_request(api).completion(^(id data, NSError *error) {
    }).resume();
```
