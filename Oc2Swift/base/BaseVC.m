//
//  BaseVC.m
//  Oc2Swift
//
//  Created by behind47 on 2022/7/18.
//
/// 基类，可以承载一些通用的方法，比如InjectionIII的injected方法

#import <Foundation/Foundation.h>
#import "BaseVC.h"

@implementation BaseVC

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithFrame:CGRectZero];
}

/// InjectionIII需要的方法，在这个hook里的方法会在热更新触发时被调用
- (void)injected {
#if DEBUG
    [self viewDidLoad];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
