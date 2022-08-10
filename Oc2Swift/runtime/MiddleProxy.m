//
//  MiddleProxy.m
//  Oc2Swift
//
//  Created by behind47 on 2022/8/10.
//

#import "MiddleProxy.h"

@implementation MiddleProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    return [[MiddleProxy alloc] initWithTarget:target];
}

// NSObject消息转发三大流程
// step 1 动态方法解析 NSProxy没有定义这个方法
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    return [super resolveInstanceMethod:sel];
//}
//+ (BOOL)resolveClassMethod:(SEL)sel {
//    return [super resolveClassMethod:sel];
//}
//
// step 2 快速转发 NSProxy没有定义这个方法
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    return self.target;
//}

// step 3 完整消息转发 NSProxy只定义了这一个消息转发方法
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.target methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.target];
}

@end
