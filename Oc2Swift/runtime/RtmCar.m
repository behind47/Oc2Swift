//
//  RtmCar.m
//  Oc2Swift
//
//  Created by behind47 on 2022/7/19.
//

#import <Foundation/Foundation.h>
#import "RtmCar.h"
@implementation RtmCar

/// 如果getter和setter方法都重写了，就需要用\@synthesize指明属性的内部成员变量，将属性声明的方法绑定到内部成员变量上。
/// 这里也可以把speed绑定到其他成员变量比如carType上
@synthesize speed = _speed;

- (NSInteger)speed {
    return _speed;
}

- (void)setSpeed:(NSInteger)speed {
    _speed = speed;
}
@end
