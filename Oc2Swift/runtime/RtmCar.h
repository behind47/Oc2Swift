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
/// 属性声明的6种修饰符
/// 原子性修饰符      引用计数修饰符      空修饰符        读写修饰符       setter/getter修饰符
/// nonatomic       assign                   nullable            readwrite           setter=setXXX:, getter=XXX
/// atomic              weak                      nonnull             readonly
///             strong
///             copy
@property (nonatomic, strong, nonnull, readwrite, setter=setCarType:, getter=carType) RtmCarType *carType;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, strong) NSArray<RtmCarColor *> * _Nonnull carColorArr;
@end
