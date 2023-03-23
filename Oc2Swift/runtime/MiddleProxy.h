//
//  MiddleProxy.h
//  Oc2Swift
//
//  Created by behind47 on 2022/8/10.
//

#import "BaseVC.h"
#import "RuntimeVC.h"

@interface MiddleProxy : NSProxy // NSProxy是专门用来做消息转发的，比NSObject效率更高
@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;
@end
