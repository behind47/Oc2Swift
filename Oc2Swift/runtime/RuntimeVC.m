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
    
}

@end
