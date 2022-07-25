//
//  RuntimeVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//
/// 1. 交换两个类方法

#import <Foundation/Foundation.h>
#import "RuntimeVC.h"
#import "RtmCar.h"
#import <objc/runtime.h>

@implementation RuntimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 字段类型：字典、基本类型、数组
    NSDictionary *dict = @{
        @"carType":@{@"type":@"BMW"},
        @"speed":@120,
        @"carColorArr":@[@{@"color":@"red"},@{@"color":@"blue"}]
    };
    RtmCar *car = [RtmCar objectWithDict:dict];
    NSLog(@"type = %@, speed = %ld", car.carType, car.speed);
    RtmCarColor *color = [car.carColorArr firstObject];
    NSLog(@"color = %@", color);
    
    RtmCar __weak *a = [RtmCar new];
    a.speed = 123;
    NSLog(@"behind%ld", (long)a.speed); // 打出来是0，因为weak对象定义后就被释放了
    id strongB = [RtmCar new];
    RtmCar __weak *b = strongB;
    b.speed = 123;
    NSLog(@"behind%ld", (long)b.speed); // 打出来是123，因为在对象上增加了一个strong引用，保持了对象
    RtmCar __weak *c;
    {
        id strongC = [RtmCar new];
        c = strongB;
        c.speed = 123;
    }
    NSLog(@"behind%ld", (long)c.speed); // 打出来是0，因为strongC超出作用域后自动释放引用，于是weak对象自动释放
    
    NSError *error = nil;
    NSError * __strong *pError = &error;
    
    [self testMsgModel];
}

/// 测试OC消息机制
/// 向object发送方法调用消息时：
/// 1. 如果object实现了方法，则调用方法
/// 2. 否则，调用resolveInstanceMethod方法或者resolveClassMethod方法处理，如果在这里用class_addMethod动态添加方法，那么被动态添加的方法就会被调用。
/// 3. 否则，检查是否存在备用对象，如果有，则调用forwardingTargetForSelector将消息转发给备用对象。这个过程叫直接转发。
/// 4. 否则，调用methodSignatureForSelector检查方法签名的有效性，如果有效，则返回一个函数签名对象NSMethodSignature，然后走forwardInvocation，在备用对象上调用该方法。
/// 5. 否则，走到doesNotRecognizeSelector方法，这个方法定义在NSObject，抛出异常。
- (void)testMsgModel {
    UIButton *testMsgModelBtn = [UIButton new];
    [self.view addSubview:testMsgModelBtn];
    testMsgModelBtn.translatesAutoresizingMaskIntoConstraints = false;//禁止将AutoresizingMask默认设置转为约束
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:testMsgModelBtn
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:100];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:testMsgModelBtn
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1
                                                            constant:50];
    [testMsgModelBtn.superview addConstraints:@[top, left]];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:testMsgModelBtn
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1
                                                              constant:100];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:testMsgModelBtn
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:40];
    [testMsgModelBtn addConstraints:@[width, height]];
    testMsgModelBtn.backgroundColor = [UIColor systemPinkColor];
    [testMsgModelBtn setTitle:@"测试OC消息机制的流程" forState:UIControlStateNormal];
    [testMsgModelBtn addTarget:self action:@selector(speed) forControlEvents:UIControlEventTouchUpInside];
}
/// 1
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%s %s", __FILE__, __FUNCTION__);
    if ([NSStringFromSelector(sel) isEqualToString:@"speed"]) {
        class_addMethod(self, sel, (void (*)(void))speed, "v@:");
    }
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"%s %s", __FILE__, __FUNCTION__);
    return [super resolveClassMethod:sel];
}

int speed(id obj, SEL method) {
    NSLog(@"实例:%@, 方法名:%@", obj, NSStringFromSelector(method));
    return 11;
}

/// 2
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%s %s", __FILE__, __FUNCTION__);
    if ([NSStringFromSelector(aSelector) isEqualToString:@"speed"]) {
        RtmCar *car = [RtmCar new];
        car.speed = 12;
        return car;
    }
    return [super forwardingTargetForSelector:aSelector];
}
/// 3
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%s %s", __FILE__, __FUNCTION__);
    if ([NSStringFromSelector(aSelector) isEqualToString:@"speed"]) {
        return [NSMethodSignature signatureWithObjCTypes:"i@:"];//规则: 返回值 函数名: 参数列表
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%s %s", __FILE__, __FUNCTION__);
    if ([NSStringFromSelector(anInvocation.selector) isEqualToString:@"speed"]) {
        RtmCar *car = [RtmCar new];
        car.speed = 13;
        [anInvocation invokeWithTarget:car];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end
