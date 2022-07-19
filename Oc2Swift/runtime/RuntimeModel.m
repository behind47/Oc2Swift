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

#pragma mark -- 字典转model对象
+ (instancetype)objectWithDict:(NSDictionary *)dict {
    id obj = [self new];
    // 获取model对象定义的属性列表
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int index = 0; index < count; index++) {
        Ivar ivar = ivarList[index];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSLog(@"ivarName: %@", ivarName);
        NSString *key = [ivarName substringToIndex:1]; // TODO:为什么1？
        // 根据属性名去dict里取值
        id value = [dict objectForKey:key];
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // 判断value是否是字典，这里运用了一个代码规范——如果属性类型包含"NS"，则是系统类型，否则是自定义类型
        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType containsString:@"NS"]) {
            // 处理类型字符串，@\"User\" -> User
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            Class modelClass = NSClassFromString(ivarType);
            // 因为value是字典，所以递归地将字典转为model对象
            if (modelClass) {
                value = [modelClass objectWithDict:value];
            }
        } else if ([value isKindOfClass:[NSArray class]]) {
            // 对数组的处理，递归处理数组元素
            NSMutableArray *arr = [NSMutableArray new];
            [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arr addObject:[self objectWithDict:obj]];
            }];
            value = arr;
        }
        if (value) {
            [obj setValue:value forKey:key];
        }
    }
    free(ivarList);
    return obj;
}
@end
