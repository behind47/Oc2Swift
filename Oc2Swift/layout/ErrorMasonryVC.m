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

#define ErrorMasonryVC_ON 0 // 错误的做法，给center赋值CGPoint值。在拖动的时候为center添加偏移量更新center
#define RightMasonryVC_ON 0 // 正确的做法,给left,top赋值数值。在拖动的时候为left,top添加偏移量更新left,top
#define ErrorMasonryVC_ON2 1 // 错误的做法2，给centerX,centerY赋值数值。在拖动的时候为centerX,centerY添加偏移量更新center

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
#elif RightMasonryVC_ON
        make.left.top.mas_equalTo(100);
#elif ErrorMasonryVC_ON2
        make.centerX.mas_equalTo(100);
        make.centerY.mas_equalTo(100);
#else
        make.left.equalTo(self.view).offset(30);
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
#elif RightMasonryVC_ON
            make.left.mas_equalTo(sender.frame.origin.x + translation.x);
            make.top.mas_equalTo(sender.frame.origin.y + translation.y);
#elif ErrorMasonryVC_ON2
            make.centerX.mas_equalTo(sender.center.x + translation.x);
            make.centerY.mas_equalTo(sender.center.y + translation.y);
#else
            
#endif
        }];
        [recognizer setTranslation:CGPointZero inView:sender];
    }
}

/// @encode(type)的用法：获取数据类型的const char * 形式的值，常用作objcType
- (void)testEncode {
    NSDictionary *dic = @{
        @"1": [NSNumber numberWithInt:1],
        @"2": [NSNumber numberWithBool:true],
        @"3": [NSNumber numberWithChar:'a'],
        @"4": [NSNumber numberWithFloat:11.1]
    };
    [dic.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const char *objcType = [obj objCType];
        if (strcmp(objcType, @encode(int)) == 0) {
            NSLog(@"obj value: %d", [obj intValue]);
        } else if (strcmp(objcType, @encode(BOOL)) == 0) {
            NSLog(@"obj value: %i", [obj boolValue]);
        } else if (strcmp(objcType, @encode(char)) == 0) {
            NSLog(@"obj value: %c", [obj charValue]);
        } else if (strcmp(objcType, @encode(float)) == 0) {
            NSLog(@"obj value: %f", [obj floatValue]);
        }
    }];
}

@end
