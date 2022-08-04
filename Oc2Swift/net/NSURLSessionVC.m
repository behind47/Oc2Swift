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

@interface NSURLSessionVC() <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURL *downloadURL;
@property (nonatomic, strong) NSURLSession *session; // 复用session就是复用TCP连接，这是HTTP2.0新特性
@end

@implementation NSURLSessionVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testDownload];
    [self testDotDownloadTask];
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

/// 断点续传
- (void)testDotDownloadTask {
    self.downloadURL = [NSURL URLWithString:@"https://bkimg.cdn.bcebos.com/pic/f9dcd100baa1cd11397333cabf12c8fcc2ce2d16?x-bce-process=image/watermark,image_d2F0ZXIvYmFpa2U4MA==,g_7,xp_5,yp_5/format,f_auto"];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.downloadURL];
    NSURLSessionDownloadTask *task;
    NSString *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, true).firstObject;
    NSString *resumePath = [library stringByAppendingPathComponent:[self.downloadURL relativePath]];
    NSData *resumeData = [[NSData alloc] initWithContentsOfFile:resumePath];
    if (resumeData) {
        task = [self.session downloadTaskWithResumeData:resumeData]; // 使用之前存放的resumeData可以进行断点续传
    }
    /// completionHandler == nil 时才走delegate的回调方法
    if (!task) {
#if 1
        task = [self.session downloadTaskWithRequest:request];
#else
        task = [session downloadTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // handler的优先级高于delegate的回调方法
            NSLog(@"%s %s", __FILE__ ,__FUNCTION__);
        }];
#endif
    }
    [task resume];
    // 取消下载task时可以将断点下载的信息存到resumeData里，暂存到本地，后面通过这个文件来断点续传
//    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
//        [resumeData writeToFile:resumePath atomically:true];
//    }];
}

// MARK: getter
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setTimeoutIntervalForRequest:60];
        _session = [NSURLSession sessionWithConfiguration:config
                                                              delegate:self
                                                         delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
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

// MARK: NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat progress = totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"%s %s %f", __FILE__, __FUNCTION__, progress);
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
}

@end
