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
#import "AFNetworking.h"

@interface NSURLSessionVC() <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSURL *downloadURL;
@property (nonatomic, strong) NSURLSession *session; // 复用session就是复用TCP连接，这是HTTP2.0新特性
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *labelArr;
@property (nonatomic, strong) NSArray<NSString *> *selectorArr;
@end

@implementation NSURLSessionVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)dealloc {
    NSLog(@"%s dealloc", __FILE__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
//    [self testDownload];
    [self testDotDownloadTask];
}

- (void)commonInit {
    self.labelArr = @[
        @"测试下载",
        @"测试断点续传",
        @"测试AFN下载任务",
    ];
    self.selectorArr = @[
        NSStringFromSelector(@selector(testDownload)),
        NSStringFromSelector(@selector(testDotDownloadTask)),
        NSStringFromSelector(@selector(testAFNDownloadTask)),
    ];
    [self tableView];
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
    [session finishTasksAndInvalidate];
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

- (void)testAFNDownloadTask {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"https://bkimg.cdn.bcebos.com/pic/f9dcd100baa1cd11397333cabf12c8fcc2ce2d16?x-bce-process=image/watermark,image_d2F0ZXIvYmFpa2U4MA==,g_7,xp_5,yp_5/format,f_auto"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"File downloaded to : %@", filePath);
    }];
    [downloadTask resume];
    [manager invalidateSessionCancelingTasks:false resetSession:true];
}

#pragma mark - getter
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    }
    return _tableView;
}


#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"%s %s", __FILE__ ,__FUNCTION__);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 在这里处理阶段性接收到的data
    NSLog(@"%s %s", __FILE__ ,__FUNCTION__);
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"%s %s", __FILE__ ,__FUNCTION__);
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat progress = totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"%s %s %f", __FILE__, __FUNCTION__, progress);
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL selector = NSSelectorFromString([self.selectorArr objectAtIndex:indexPath.row]);
    if ([self respondsToSelector:selector]) {
        IMP implementation = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)implementation;
        func(self, selector);
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.labelArr objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.labelArr count];
}

@end
