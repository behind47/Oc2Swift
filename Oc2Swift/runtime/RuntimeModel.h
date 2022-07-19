//
//  RuntimeModel.h
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//

#ifndef RuntimeModel_h
#define RuntimeModel_h


#endif /* RuntimeModel_h */

#import <Foundation/Foundation.h>

@protocol RuntimeModelDelegate<NSObject>
@optional
+ (NSDictionary *)arrayContainModelClass; // 如果dict里取值是数组，则无法获取数组里的元素类型，因此要实现这个方法来规定，返回一个dict，规定某个数组属性字段的数组元素类型类名
@end

@interface RuntimeModel : NSObject<RuntimeModelDelegate>
+ (NSString *)classMethoda;
+ (NSString *)classMethodb;
+ (NSString *)rawClassMethoda;
+ (NSString *)rawClassMethodb;

+ (instancetype)objectWithDict:(NSDictionary *)dict;
@end


