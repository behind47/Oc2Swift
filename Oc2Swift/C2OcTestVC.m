//
//  C2OcTestVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/5/19.
//
/// 这个页面用来测试Oc到flutter的交互，目前可以打开flutter页面

#import <Foundation/Foundation.h>
#import "C2OcTestVC.h"
#import "Oc2Swift-Swift.h"
@import Flutter;

@implementation C2OcTestVC

- (void)viewDidLoad {
    float sWidth = [UIScreen mainScreen].bounds.size.width;
    
    [super viewDidLoad];
    // Make a button to call the showFlutter function when pressed.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(showFlutter)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show Flutter!" forState:UIControlStateNormal];
    button.backgroundColor = UIColor.blueColor;
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
    
    UIView *topicView = [UIView new];
    topicView.frame = CGRectMake(80.0, 260.0, sWidth, 100);
    topicView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topicView];
}

/// flutter页面的入口
- (void)showFlutter {
    FlutterEngine *flutterEngine = ((AppDelegate *)UIApplication.sharedApplication.delegate).flutterEngine;
    CustomFlutterVC *flutterViewController = [[CustomFlutterVC alloc] initWithEngine:flutterEngine
                                                                                         nibName:nil bundle:nil];
    [self.navigationController pushViewController:flutterViewController animated:TRUE];
}
@end
