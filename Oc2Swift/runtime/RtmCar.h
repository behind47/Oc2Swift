//
//  RtmCar.h
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//
///  头文件不能添加依赖到target，因此在编译期链接阶段找不到RtmCar类，NSClassFromString也不能加载到Class，加上oc文件即可。

#import "RtmCarColor.h"
#import "RtmCarType.h"

@interface RtmCar : RuntimeModel
@property (nonatomic, strong) RtmCarType *carType;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, strong) NSArray<RtmCarColor *> *carColorArr;
@end
