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
+ (NSDictionary *)arrayContainModelClass;
@end

@interface RuntimeModel : NSObject
+ (NSString *)classMethoda;
+ (NSString *)classMethodb;
+ (NSString *)rawClassMethoda;
+ (NSString *)rawClassMethodb;

+ (instancetype)objectWithDict:(NSDictionary *)dict;
@end


