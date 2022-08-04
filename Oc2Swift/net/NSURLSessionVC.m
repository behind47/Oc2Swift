//
//  NSURLSessionVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/8/4.
//
/// 有两种使用方式：
/// 1. 使用block，传入URL/Request来创建task，优先级高于2。偏向于对response的处理，不能控制请求过程。设置了completionHandler就不会调用delegate的回掉方法。
/// 2. 使用delegate创建普通的task，偏向于对请求过程的控制。

#import <Foundation/Foundation.h>
#import "NSURLSessionVC.h"

@interface NSURLSessionVC() <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@end

@implementation NSURLSessionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testDownload];
}

- (void)testDownload {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"https://bkimg.cdn.bcebos.com/pic/f9dcd100baa1cd11397333cabf12c8fcc2ce2d16?x-bce-process=image/watermark,image_d2F0ZXIvYmFpa2U4MA==,g_7,xp_5,yp_5/format,f_auto"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionTask *task;
    /// completionHandler == nil 时才走delegate的回调方法
#if 0
    task = [session dataTaskWithRequest:request];
#else
    task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // handler的优先级高于delegate的回调方法
        NSLog(@"%s %s", __FILE__ ,__FUNCTION__);
    }];
#endif
    [task resume];
}

// MARK: NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"%s %s", __FILE__ ,__FUNCTION__);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 在这里处理阶段性接收到的data
    NSLog(@"%s %s", __FILE__ ,__FUNCTION__);
}

// MARK: NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"%s %s", __FILE__ ,__FUNCTION__);
}

@end
