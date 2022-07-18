//
//  RuntimeVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//
/// 1. 交换两个类方法

#import <Foundation/Foundation.h>
#import "RuntimeVC.h"
#import <objc/runtime.h>

@implementation RuntimeVC

+ (void)load {
    Method methoda = class_getClassMethod(self, @selector(classMethoda));
    Method methodb = class_getClassMethod(self, @selector(classMethodb));
    method_exchangeImplementations(methoda, methodb);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"[RuntimeVC classMethoda] : ");
    [RuntimeVC classMethoda];
    NSLog(@"[RuntimeVC classMethodb] : ");
    [RuntimeVC classMethodb];
}

#pragma mark -- 在类加载阶段交换两个类方法
/// 怎么处理参数列表不一致的情况？
+ (void)classMethoda {
    NSLog(@"%s classMethoda", __FUNCTION__);
}

+ (void)classMethodb {
    NSLog(@"%s classMethodb", __FUNCTION__);
}

@end
