//
//  RuntimeModel.m
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//
/// 字典转实体类
/// 1. 用runtime获取到的类属性名，有一个_前缀，因此要从下标1开始取字符串。
/// 2. 用runtime获取到的类属性类型，需要进行字符串处理后获取到类名字符串，然后走NSClassFromString获取类对象。
/// 3. 用类属性名作为key在字典中取值，取到的是一个基本类型、array或dictionary
/// 如果类属性类型是基本类型，取值也是基本类型，就直接设置到map中，取值是其他类型的不合法；
/// 如果类属性是自定义类，则用取值递归转自定义类实体，然后设置到map中；
/// 如果类属性是dictionary或array，它没有类属性字段，无法递归转自定义实体类，如果要转的话。对于dictionary，可以规定对于类属性名提供key和value的两个类型，然后递归解析取值到key，value，插入map，最后把整个map插入map。对于array，可以规定对于类属性名提供array成员的类型，然后递归解析取值到成员类型，插入array，最后把整个array插入map。

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
        NSString *key = [ivarName substringFromIndex:1]; // 因为获取到的字段名有一个_前缀，因此从1开始取字符串，去掉_
        // 根据属性名去dict里取值
        id value = [dict objectForKey:key];
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // 判断value是否是字典，这里运用了一个代码规范——如果属性类型包含"NS"，则是系统类型，否则是自定义类型
        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType containsString:@"NS"]) {
            // 处理类型字符串，@"@\"User\""-> @"User",外层的@""不属于字符串内容，所以不受字符串处理方法影响
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
            NSDictionary *map = [self arrayContainModelClass];
            NSString *elementType = [map objectForKey:key];
            Class elementClass = NSClassFromString(elementType);
            [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id model = [elementClass objectWithDict:obj];
                if (model != nil) {
                    [arr addObject:model];
                }
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

#pragma mark -- RuntimeModelDelegate
+ (NSDictionary *)arrayContainModelClass {
    return @{
        @"carColorArr":@"RtmCarColor"
    };
}
@end
