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
}

@end
