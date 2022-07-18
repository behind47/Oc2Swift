//
//  BaseVC_OC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//
/// 基类，可以承载一些通用的方法，比如InjectionIII的injected方法

#import <Foundation/Foundation.h>
#import "BaseVC_OC.h"

@implementation BaseVC_OC

/// InjectionIII需要的方法，在这个hook里的方法会在热更新触发时被调用
- (void)injected {
#if DEBUG
    [self viewDidLoad];
#endif
}

@end
