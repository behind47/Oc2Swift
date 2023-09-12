//
//  ErrorMasonryVC.m
//  Oc2Swift
//
//  Created by behind47 on 2023/9/1.
//
/// 测试一下
/// 搞一个可以拖动的view，用masonry通过更新约束的方式实现对其拖动的效果，从masonry实现上分析为什么会失败

#import <Foundation/Foundation.h>
#import "ErrorMasonryVC.h"
#import <Masonry/Masonry.h>

#define ErrorMasonryVC_ON 0 // 错误的做法
#define ErrorMasonryVC_ON2 0 // 错误的做法2

@implementation ErrorMasonryVC : BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *focusView = [UIView new];
    focusView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:focusView];
    [focusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
#if ErrorMasonryVC_ON
        make.center.mas_equalTo(CGPointMake(100, 100));
#elif ErrorMasonryVC_ON2
        make.left.top.mas_equalTo(100);
#else
        
#endif
    }];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMove:)];
    [focusView addGestureRecognizer:pan];
}

#pragma mark - Event
- (void)dragMove:(UIPanGestureRecognizer *)recognizer {
    UIView *sender = recognizer.view;
    CGPoint translation = [recognizer translationInView:sender];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [sender mas_updateConstraints:^(MASConstraintMaker *make) {
#if ErrorMasonryVC_ON
            make.center.mas_equalTo(CGPointMake(sender.center.x + translation.x, sender.center.y + translation.y));
#elif ErrorMasonryVC_ON2
            make.left.mas_equalTo(sender.center.x + translation.x);
            make.top.mas_equalTo(sender.center.y + translation.y);
#else
            
#endif
        }];
        [recognizer setTranslation:CGPointZero inView:sender];
    }
}

@end
