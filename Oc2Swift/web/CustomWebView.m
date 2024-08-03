//
//  CustomWebView.m
//  Oc2Swift
//
//  Created by behind47 on 2024/7/29.
//

#import "CustomWebView.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>

@interface CustomWebView () <WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation CustomWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.allowsInlineMediaPlayback = true;
    configuration.allowsAirPlayForMediaPlayback = true;
    
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
    [contentController addScriptMessageHandler:self name:@"pop2Native"];
    configuration.userContentController = contentController;
    
    WKPreferences *prefrence = [[WKPreferences alloc] init];
    prefrence.javaScriptEnabled = true;
    prefrence.javaScriptCanOpenWindowsAutomatically = true;
    configuration.preferences = prefrence;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.allowsBackForwardNavigationGestures = true;
    self.webView.translatesAutoresizingMaskIntoConstraints = false;
//    self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = true;
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:80"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"pop2Native"]) {
        NSString *messageBody = (NSString *)message.body;
        NSLog(@"%@", messageBody);
        [self.navigationController popViewControllerAnimated:true];
    }
}

@end
