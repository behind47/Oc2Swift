//
//  RuntimeModel.m
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//

#import "RuntimeModel.h"
#import <objc/runtime.h>

@implementation RuntimeModel

+ (void)load {
    // 交换两个类方法：classMethoda && classMethodb
    Method methoda = class_getClassMethod(self, @selector(classMethoda));
    Method methodb = class_getClassMethod(self, @selector(classMethodb));
    method_exchangeImplementations(methoda, methodb);
}

#pragma mark -- 在类加载阶段交换两个类方法
/// 怎么处理参数列表不一致的情况？
+ (NSString *)classMethoda {
    return [RuntimeModel rawClassMethoda];
}

+ (NSString *)classMethodb {
    return [RuntimeModel rawClassMethodb];
}

+ (NSString *)rawClassMethoda {
    return [NSString stringWithFormat:@"%s", __FUNCTION__];
}

+ (NSString *)rawClassMethodb {
    return [NSString stringWithFormat:@"%s", __FUNCTION__];
}

@end
