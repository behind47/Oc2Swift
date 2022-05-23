//
//  C2OcTestVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/5/19.
//

#import <Foundation/Foundation.h>
#import "C2OcTestVC.h"
#import "Oc2Swift-Swift.h"
@import Flutter;

@implementation C2OcTestVC

- (void)viewDidLoad {
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
}

- (void)showFlutter {
    FlutterEngine *flutterEngine = ((AppDelegate *)UIApplication.sharedApplication.delegate).flutterEngine;
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] initWithEngine:flutterEngine
                                                                                         nibName:nil bundle:nil];
    [self.navigationController pushViewController:flutterViewController animated:TRUE];
}
@end
