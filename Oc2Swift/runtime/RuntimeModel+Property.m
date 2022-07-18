//
//  RuntimeModel+Property.m
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//

#import "RuntimeModel+Property.h"
#import <objc/runtime.h>

@implementation RuntimeModel (Property)

- (void)setName:(NSString *)name {
    // 将传入的值的内存与对象关联起来
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, @"name");
}

@end
