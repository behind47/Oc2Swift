//
//  GestureViewController.m
//  Oc2Swift
//
//  Created by behind47 on 2025/2/20.
//

#import "GestureViewController.h"

@interface GestureViewController ()
@property (nonatomic, strong) UIView *subViewB;
@property (nonatomic, strong) UIView *subViewC;
@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // ... existing code ...

    // 创建子视图b和子视图c
    self.subViewB = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    self.subViewB.backgroundColor = [UIColor redColor];
    self.subViewB.userInteractionEnabled = YES; // 确保subViewB可以响应用户交互
    [self.view addSubview:self.subViewB];

    self.subViewC = [[UIView alloc] initWithFrame:CGRectMake(200, 50, 100, 100)];
    self.subViewC.backgroundColor = [UIColor blueColor];
    self.subViewC.userInteractionEnabled = YES; // 确保subViewC可以响应用户交互
    [self.view addSubview:self.subViewC];

    // 添加手势gesture1到视图a
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture1:)];
    gesture1.cancelsTouchesInView = NO; // 确保gesture1不会干扰子视图的手势识别
    [self.view addGestureRecognizer:gesture1];
    NSLog(@"Added gesture1 to main view");

    // 添加手势gesture2到子视图b和子视图c
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture2:)];
    [self.subViewB addGestureRecognizer:gesture2];
    //一个UITapGestureRecognizer只能添加到一个UIView上，添加到多个UIView上时，后面的会覆盖前面的，只有最后一个生效。
//    [self.subViewC addGestureRecognizer:gesture2];
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture2:)];
    [self.subViewC addGestureRecognizer:gesture3];
    NSLog(@"Added gesture2 to subViewB and subViewC");
}

- (void)handleGesture1:(UITapGestureRecognizer *)gesture {
    NSLog(@"Gesture 1 triggered");
}

- (void)handleGesture2:(UITapGestureRecognizer *)gesture {
    NSLog(@"Gesture 2 triggered");
    if (gesture.view == self.subViewB) {
        NSLog(@"Gesture 2 triggered on subViewB");
    } else if (gesture.view == self.subViewC) {
        NSLog(@"Gesture 2 triggered on subViewC");
    }
}

@end

