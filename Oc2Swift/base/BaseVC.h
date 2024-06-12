//
//  BaseVC.h
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//
/// UIViewController有两个NS_DESIGNATED_INITIALIZER的init方法，是基于nib和storyboard文件的，这里用不到，所以覆盖掉。

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

@end
