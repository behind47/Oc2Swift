//
//  NSInvocationVC.h
//  Oc2Swift
//
//  Created by behind47 on 2022/7/11.
//

#ifndef NSInvocationVC_h
#define NSInvocationVC_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSInvocationVC : UIViewController

/// 执行target对象的aSelector方法，并传入参数arguments
/// @param aSelector 需要执行的方法
/// @param target 执行方法的对象
/// @param arguments 方法执行需要的参数列表
+ (id)performSelector:(SEL)aSelector onTarget:(id)target withArguments:(NSArray<id> *)arguments;

/// 将指定类型的void *数据转化成CF对象
/// @param voidValue   void*数据
/// @param cfType  要转换成的cf对象的类型
+ (id)obtainCfValue:(void *)voidValue ofType:(const char*)cfType;
@end


#endif /* invocationVC_h */
