//
//  ReviewInWindowVC.h
//  Oc2Swift
//
//  Created by behind47 on 2023/7/4.
//

#ifndef ReviewInWindowVC_h
#define ReviewInWindowVC_h

#import "BaseVC.h"

@interface ReviewInWindowVC : BaseVC

@end

@interface ReviewInWindow : UIWindow
+ (instancetype)sharedInstance;
- (void)show;
- (void)hide;
@end

#endif /* ReviewInWindowVC_h */
